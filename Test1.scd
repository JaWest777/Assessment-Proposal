// Define a simple synth in SuperCollider
(
SynthDef("simpleSynth", {
    |freq = 440, amp = 0.5, sustain = 1.0|
    var env, sound;

    // Create an amplitude envelope
    env = EnvGen.kr(
        Env.adsr(attackTime: 0.01, decayTime: 0.3, sustainLevel: 0.5, releaseTime: 0.5),
        gate: 1,
        doneAction: 2
    );

    // Generate sound with a saw wave
    sound = Saw.ar(freq) * env * amp;

    // Send the sound to the speakers
    Out.ar(0, sound.dup);
}).add;
)

// Define an audio track SynthDef
(
SynthDef("audioTrack", {
    |bufnum, amp = 0.5|
    var sound;

    // Play the audio buffer
    sound = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum)) * amp;

    // Send the sound to the speakers
    Out.ar(0, sound);
}).add;
)

// Play the synth programmatically
(
Synth("simpleSynth", [
    \freq, 440,   // A4
    \amp, 0.7,    // Amplitude
    \sustain, 1.0 // Note duration
]);
)

// Load an audio file
(
var buf;
buf = Buffer.read(s, "/path/to/your/audiofile.wav");
buf.loadToFloatArray({ |data| "Audio file loaded successfully!".postln; });
)

// Play an audio file as a track
(
Synth("audioTrack", [
    \bufnum, buf.bufnum,
    \amp, 0.8
]);
)

// MIDI Control Example
(
MIDIIn.connectAll;

MIDIdef.noteOn(\playSynth, {
    |vel, num|
    var freq = num.midicps; // Convert MIDI note to frequency
    Synth("simpleSynth", [\freq, freq, \amp, vel / 127]);
});
)
