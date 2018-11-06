from tkinter import *
import json
import numpy as np
from tkinter import messagebox

experimentConfig = {'forceGain': -0.018,
                    'forceBias': 1900,
                    'experimentPeriod': 150000,
                    'kSpring': 1000,
                    'bDamper': 20,
                    'numberFreq': 5,
                    'freqs': [],
                    'phases': [],
                    'magnitudes': []}

experimentEntries = {
'freqs_entry': [],
'phases_entry': [],
'magnitudes_entry': []
}


root = Tk(screenName="Config JSON Editor")
saveScreen = Tk()
root.title("Config Editor")
saveScreen.title("Config Editor")
root.resizable(False, False)
saveScreen.resizable(False, False)
saveScreen.withdraw()

def saveAndNext():
    n_val = NFrequencies_entry.get()
    erroneousValue=True
    try:
        n_int = int(n_val)
        if n_int <= 0 or n_int>10:
            raise ValueError
        else:
            erroneousValue = False
    except ValueError:
        messagebox.showerror("Value Error", "Number of frequencies is not appropriate!")
        print("Number of frequencies is not appropriate!")
        return

    # Number of frequencies is appropriate
    if not erroneousValue:
        root.withdraw()

        freq_label = Label(saveScreen, text="Frequencies")
        freq_label.grid(row=0, column=0)

        mag_label = Label(saveScreen, text="Magnitudes")
        mag_label.grid(row=0, column=1)

        phas_label = Label(saveScreen, text="Phases")
        phas_label.grid(row=0, column=2)
        for i in range(n_int):

            freq_default = np.linspace(0.1, 1.3, num=n_int)
            entryFreq = Entry(saveScreen)
            entryFreq.grid(row=i+1, column=0)
            entryFreq.insert(END, round(freq_default[i], 2))

            entryMags = Entry(saveScreen)
            entryMags.grid(row=i+1, column=1)
            entryMags.insert(END, 45/n_int)

            entryPhas = Entry(saveScreen)
            entryPhas.grid(row=i+1, column=2)
            entryPhas.insert(END, 0)

            experimentEntries['freqs_entry'].append(entryFreq)
            experimentEntries['magnitudes_entry'].append(entryMags)
            experimentEntries['phases_entry'].append(entryPhas)
        saveButton.grid(row=n_int+1, column=2)
        saveScreen.update()
        saveScreen.deiconify()


def saveTheValues():
    fgain_val = forceGain_entry.get()
    fbias_val = forceBias_entry.get()
    exPer_val = exPeriod_entry.get()
    kSpring_val = springConstant_entry.get()
    bDamper_val = damperValue_entry.get()
    nFreq_val = NFrequencies_entry.get()

    try:
        experimentConfig['forceGain'] = float(fgain_val)
        experimentConfig['forceBias'] = int(fbias_val)
        experimentConfig['experimentPeriod'] = int(exPer_val)
        experimentConfig['kSpring'] = float(kSpring_val)
        experimentConfig['bDamper'] = float(bDamper_val)
        experimentConfig['numberFreq'] = int(nFreq_val)
        for i in range(experimentConfig['numberFreq']):
            experimentConfig['freqs'].append(float(experimentEntries['freqs_entry'][i].get()))
            experimentConfig['magnitudes'].append(float(experimentEntries['magnitudes_entry'][i].get()))
            experimentConfig['phases'].append(float(experimentEntries['phases_entry'][i].get()))
    except ValueError:
        messagebox.showerror("Value Error", "Number of frequencies is not appropriate!")
        print("Number of frequencies is not appropriate!")
        return

    for key, value in experimentConfig.items():
        print(key)
        print(value)
    with open('haptic.json', 'w') as outfile:
        outfile.write(json.dumps(experimentConfig, ensure_ascii=False, separators=(',', ':')))
    quit()

try:
    with open('haptic.json') as json_data:
        exConf = json.load(json_data)
        print(json.dumps(exConf, indent=4, separators=(',', ': ')))
except FileNotFoundError:
    print("haptic.json file does not exists!")

experimentConfig['forceGain'] = exConf['forceGain']
experimentConfig['forceBias'] = exConf['forceBias']
experimentConfig['experimentPeriod'] = exConf['experimentPeriod']
experimentConfig['kSpring'] = exConf['kSpring']
experimentConfig['bDamper'] = exConf['bDamper']
experimentConfig['numberFreq'] = exConf['numberFreq']


forceGain_label      = Label(root, text="Force Gain")
forceBias_label      = Label(root, text="Force Bias")
exPeriod_label       = Label(root, text="Experiment Period (s)")
springConstant_label = Label(root, text="Spring Constant")
damperValue_label    = Label(root, text="Damping Value")
NFrequencies_label   = Label(root, text="Number Of frequencies")

forceGain_entry      = Entry(root)
forceGain_entry.insert(END, experimentConfig['forceGain'])
forceBias_entry      = Entry(root)
forceBias_entry.insert(END, experimentConfig['forceBias'])
exPeriod_entry       = Entry(root)
exPeriod_entry.insert(END, experimentConfig['experimentPeriod'])
springConstant_entry = Entry(root)
springConstant_entry.insert(END, experimentConfig['kSpring'])
damperValue_entry    = Entry(root)
damperValue_entry.insert(END, experimentConfig['bDamper'])
NFrequencies_entry   = Entry(root)
NFrequencies_entry.insert(END, experimentConfig['numberFreq'])

labels = [forceGain_label,
          forceBias_label,
          exPeriod_label,
          springConstant_label,
          damperValue_label,
          NFrequencies_label]

entries = [forceGain_entry,
           forceBias_entry,
           exPeriod_entry,
           springConstant_entry,
           damperValue_entry,
           NFrequencies_entry]

rowLocation = 0
for label in labels:
    label.grid(row=rowLocation, column=0)
    rowLocation = rowLocation + 1
entryLocation = 0
for entry in entries:
    entry.grid(row=entryLocation, column=1)
    entryLocation = entryLocation + 1

saveButton = Button(saveScreen, text="Save", command=saveTheValues)

nextPageButton = Button(root, text="Next", command=saveAndNext)
nextPageButton.grid(row=entryLocation, column=1)

root.mainloop()
