
 
 
 




window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"


      waveform add -signals /test_tb/status
      waveform add -signals /test_tb/test_synth_inst/bmg_port/RSTA
      waveform add -signals /test_tb/test_synth_inst/bmg_port/CLKA
      waveform add -signals /test_tb/test_synth_inst/bmg_port/ADDRA
      waveform add -signals /test_tb/test_synth_inst/bmg_port/DINA
      waveform add -signals /test_tb/test_synth_inst/bmg_port/WEA
      waveform add -signals /test_tb/test_synth_inst/bmg_port/DOUTA
console submit -using simulator -wait no "run"
