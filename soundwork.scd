s.boot;

b = Buffer.alloc(s,s.sampleRate*5);

b.plot:
{SoundIn.ar(0);}.play

(

x = {
	var sig;
	sig = SoundIn.ar(0);
	RecordBuf.ar(sig, b, 0, 1,0,1,1);
}.play;
)

x.free;

b.plot;
b.play;


(
SynthDef(\looperRecorder, { |bufnum = 0, record = 0, play = 1, speed = 1, loop = 1, rate = 1, in = 0|

	var micinput;
	var recordBuf;
	var playback;

    // Capture live input
    micinput = SoundIn.ar(in);

    // Record into the buffer
    recordBuf = RecordBuf.ar(micinput, bufnum, loop: loop, doneAction: Done.freeSelf, run: record);

    // Playback from the buffer
    playback = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * speed * rate, loop: loop);

    // Crossfade between playback and live input when recording
    Out.ar(0, (record * 0.5 * micinput) + (play * playback));
}).add;
)

b = Buffer.alloc(s, s.sampleRate * 10, 1);

x = Synth(\looper, [\bufnum, b.bufnum, \record, 0, \play, 1]);

x.set(\record, 1); // Start recording
x.set(\record, 0, \play, 1); // Stop recording and start playback
x.set(\speed, 1.5); // Adjust playback speed




