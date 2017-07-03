cd ./vivado
#Remember to change vivado.tcl if you want to use ILA 
./synthesize_me.sh vhdl
#Create ila project -> add signals -> generate bitstream
#cd ../test/
################ In case you need to use an ILA ##############################
#cp ../ila_0/ila_0.runs/impl_1/user_mmi64.bit ./test/
################ Othewise ####################################################
#cp ../vivado/output/user_mmi64.bit .
#./compile_me.sh
#profpga_run profpga.cfg --up
#./usertest profpga.cfg 
#profpga_run profpga.cfg --down
