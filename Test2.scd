// Audio Manipulator in SuperCollider
// Make sure to replace "path/to/your/audiofile.wav" with your audio file's actual path.

s.boot;  // Boot the server

// Load a buffer with the audio file
b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "AudioFile.wav");
(
// SynthDef for playback and manipulation
SynthDef(\audioManipulator, {
    |out=0, bufnum, rate=1, pitch=0, lowpassFreq=20000, highpassFreq=20, amp=1|
    var sig, pitchRate;

    // Calculate the pitch shift rate (adjust playback rate)
    pitchRate = rate * (2 ** (pitch / 12));  // Pitch shift formula

    // Play buffer with variable rate (for pitch shifting)
    sig = PlayBuf.ar(2, bufnum, pitchRate, loop: 1);
    sig = sig * amp;

    // Apply filters
    sig = LPF.ar(sig, lowpassFreq); // Low-pass filter
    sig = HPF.ar(sig, highpassFreq); // High-pass filter

    Out.ar(out, sig);  // Output the signal
}).add;
)
// Start the Synth with initial parameters(
(
~synth = Synth(\audioManipulator, [
    \bufnum, b.bufnum,
    \rate, 1,       // Normal playback rate
    \pitch, 0,      // No pitch shift
    \lowpassFreq, 20000,  // Full spectrum
    \highpassFreq, 20,    // No highpass cutoff
    \amp, 0.5       // Half volume
]);
)
// GUI for real-time control
(
    var window, rateSlider, pitchSlider, lowpassSlider, highpassSlider, ampSlider;
    var rateLabel, pitchLabel, lowpassLabel, highpassLabel, ampLabel;

    // Create window with no color settings (defaults to system colors)
    window = Window("Audio Manipulator", Rect(100, 100, 420, 350))
        .front;

    // Labels and sliders with no color customization (default look)
    rateLabel = StaticText(window, Rect(10, 20, 380, 20))
.string_("Playback Rate (Speed)")
        .align_(\center)
        .font_("Arial", 14);
    rateSlider = Slider(window, Rect(10, 40, 380, 20))
        .value_(1)
        .action_({ |slider| ~synth.set(\rate, slider.value); });

    pitchLabel = StaticText(window, Rect(10, 70, 380, 20))
        .string_("Pitch ")
        .align_(\center)
        .font_("Arial", 14);
    pitchSlider = Slider(window, Rect(10, 90, 380, 20))
        .value_(0)
        .action_({ |slider| ~synth.set(\pitch, slider.value); });

    lowpassLabel = StaticText(window, Rect(10, 120, 380, 20))
        .string_("Low-pass Frequency")
        .align_(\center)
        .font_("Arial", 14);
    lowpassSlider = Slider(window, Rect(10, 140, 380, 20))
        .value_(20000)
        .action_({ |slider| ~synth.set(\lowpassFreq, slider.value.linexp(0, 1, 200, 20000)); });

    highpassLabel = StaticText(window, Rect(10, 170, 380, 20))
        .string_("High-pass Frequency")
        .align_(\center)
        .font_("Arial", 14);
    highpassSlider = Slider(window, Rect(10, 190, 380, 20))
        .value_(0)
        .action_({ |slider| ~synth.set(\highpassFreq, slider.value.linexp(0, 1, 20, 20000)); });

    ampLabel = StaticText(window, Rect(10, 220, 380, 20))
        .string_("Amplitude")
        .align_(\center)
        .font_("Arial", 14);
    ampSlider = Slider(window, Rect(10, 240, 380, 20))
        .value_(0.5)
        .action_({ |slider| ~synth.set(\amp, slider.value); });

    // Window Close Action
    window.onClose_({
        ~synth.free;
        b.free;
    });
);
