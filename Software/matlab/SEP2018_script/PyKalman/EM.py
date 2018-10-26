'''
=============================
EM for Linear-Gaussian Models
=============================
This example shows how one may use the EM algorithm to estimate model
parameters with a Kalman Filter.
The EM algorithm is a meta-algorithm for learning parameters in probabilistic
models. The algorithm works by first fixing the parameters and finding a closed
form distribution over the unobserved variables, then finds new parameters that
maximize the expected likelihood of the observed variables (where the
expectation is taken over the unobserved ones). Due to convexity arguments, we
are guaranteed that each iteration of the algorithm will increase the
likelihood of the observed data and that it will eventually reach a local
optimum.
The EM algorithm is applied to the Linear-Gaussian system (that is, the model
assumed by the Kalman Filter) by first using the Kalman Smoother to calculate
the distribution over all unobserved variables (in this case, the hidden target
states), then closed-form update equations are used to update the model
parameters.
The first figure plotted contains 4 sets of lines. The first, labeled `true`,
represents the true, unobserved state of the system. The second, labeled
`blind`, represents the predicted state of the system if no measurements are
incorporated.  The third, labeled `filtered`, are the state estimates given
measurements up to and including the current time step.  Finally, the fourth,
labeled `smoothed`, are the state estimates using all observations for all time
steps.  The latter three estimates use parameters learned via 10 iterations of
the EM algorithm.
The second figure contains a single line representing the likelihood of the
observed data as a function of the EM Algorithm iteration.
'''
import numpy as np
import pylab as pl
from pykalman import KalmanFilter

# Load data and initialize Kalman Filter
# data = load_robot()
index = 0
loadedText = np.loadtxt("..\Measurements\measurement_30_09_2018_sum_of_sines.csv", delimiter=',', dtype=np.float)
loadedText[:, 0] - np.ones(loadedText.shape[0])*loadedText[0, 0] # Time starts from zero

timeVector = loadedText[:, 0]
theta_pedal = loadedText[:, 1]
theta_pedal_filt = loadedText[:, 2]
thetaDot_pedal = loadedText[:, 3]
theta_target = loadedText[:, 4]
thetaDot_target = loadedText[:, 5]

transitionMatrix = np.ones([theta_pedal.shape[0]-1, 1, 1], dtype=np.float)
print(transitionMatrix.shape)

observationMatrix = np.ones([theta_pedal.shape[0], 1, 1], dtype=np.float)
print(observationMatrix.shape)

initialTransitionCovariance = np.array([[0.000557542]], dtype=np.float)
print(initialTransitionCovariance.shape)

initialObservationCovariance = np.array([[0.0027]], dtype=np.float)
print(initialObservationCovariance.shape)

transitionOffset = np.transpose(np.array([thetaDot_pedal[0:thetaDot_pedal.shape[0]-1]/1000], dtype=np.float))
print(transitionOffset.shape)

initialStateCovariance = np.array(initialObservationCovariance, dtype=np.float)
print(initialStateCovariance.shape)


kf = KalmanFilter(
    transition_matrices=transitionMatrix,
    observation_matrices=observationMatrix,
    transition_covariance=initialTransitionCovariance,
    observation_covariance=initialObservationCovariance,
    transition_offsets=transitionOffset,
    initial_state_mean=theta_pedal[0],
    initial_state_covariance=initialObservationCovariance,
    em_vars=[
      'transition_covariance', 'observation_covariance'
    ]
)

# Learn good values for parameters named in `em_vars` using the EM algorithm
# loglikelihoods = np.zeros(1)
# for i in range(len(loglikelihoods)):
#     kf = kf.em(X=theta_pedal, n_iter=1)
#     # loglikelihoods[i] = kf.loglikelihood(theta_pedal)

# Estimate the state without using any observations.  This will let us see how
# good we could do if we ran blind.
n_dim_state = 1
n_timesteps = theta_pedal.shape[0]
blind_state_estimates = np.zeros((n_timesteps, n_dim_state))
for t in range(n_timesteps - 1):
    if t == 0:
        blind_state_estimates[t] = kf.initial_state_mean

    blind_state_estimates[t + 1] = (
      np.dot(kf.transition_matrices[t], blind_state_estimates[t])
      + kf.transition_offsets[t]
    )

# Estimate the hidden states using observations up to and including
# time t for t in [0...n_timesteps-1].  This method outputs the mean and
# covariance characterizing the Multivariate Normal distribution for
#   P(x_t | z_{1:t})
filtered_state_estimates = kf.filter(theta_pedal)[0]

# Estimate the hidden states using all observations.  These estimates
# will be 'smoother' (and are to be preferred) to those produced by
# simply filtering as they are made with later observations in mind.
# Probabilistically, this method produces the mean and covariance
# characterizing,
#    P(x_t | z_{1:n_timesteps})
smoothed_state_estimates = kf.smooth(theta_pedal)[0]

# Draw the true, blind,e filtered, and smoothed state estimates for all 5
# dimensions.
pl.figure(figsize=(16, 6))
lines_true = pl.plot(theta_pedal_filt, linestyle='-', color='b')
lines_blind = pl.plot(blind_state_estimates, linestyle=':', color='m')
lines_filt = pl.plot(filtered_state_estimates, linestyle='--', color='g')
lines_smooth = pl.plot(smoothed_state_estimates, linestyle='-.', color='r')
pl.legend(
    (lines_true[0], lines_blind[0], lines_filt[0], lines_smooth[0]),
    ('true', 'blind', 'filtered', 'smoothed')
)
pl.xlabel('time')
pl.ylabel('state')
pl.xlim(xmax=500)
pl.show()
# # # Draw log likelihood of observations as a function of EM iteration number.
# # # Notice how it is increasing (this is guaranteed by the EM algorithm)
# # pl.figure()
# # pl.plot(loglikelihoods)
# # pl.xlabel('em iteration number')
# # pl.ylabel('log likelihood')
# # pl.show()