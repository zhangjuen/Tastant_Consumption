function player = SoundGenerator(Fre,Dur)
if nargin==0
    %no input set default test audio
Fre = 3000;
Dur = 1;
end
Fs = 96000;
x = 0:1/Fs*2*pi:Dur*2*pi;
x = x*Fre;
Y = sin(x);
player = audioplayer(Y,Fs,16,1);%bit 16 default, device 1
end
%play(player)

%%info = audiodevinfo
