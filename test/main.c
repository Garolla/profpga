#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <stdint.h>
#include "profpga.h"
#include "mmi64.h"
#include "mmi64_module_regif.h"
#include "mmi64_module_devzero.h"
#include "profpga_error.h"
#include "profpga_acm.h"
#include <stdarg.h>

#define CHECK(status)  if (status!=E_PROFPGA_OK) { \
  printf(NOW("ERROR: %s\n"), profpga_strerror(status)); \
  return status;  }

uint64_t convFromBin(char * bin, int length){ 
	int i=0;
	uint64_t dec=0;
	//printf("%s\n", bin);
	while (i < length) { 
		if (bin[i] == '1') dec = dec * 2 + 1; 
		else if (bin[i] == '0') dec *= 2; 
		i++;
	} 

	//printf("%llu\n", dec); 

return dec;
}

int message_handler(const int messagetype, const char *fmt,...)
{
  int n;
  va_list ap;
  
  va_start(ap, fmt);
  n = vfprintf(stdout, fmt, ap);
  va_end(ap);
  return n;
}

char * cfgfilename = "profpga.cfg";

#define DMABUF_SIZE 100
uint64_t buf64[DMABUF_SIZE];

mmi64_error_t mmi64_main(int argc, char * argv[])
{
  profpga_handle_t * profpga;
  profpga_error_t status;
  uint64_t data[16];
  uint64_t rdata;
  uint64_t dec;
  
  FILE *fp, *frdata, *fout;
  char line[64];
  char inputfilename[64];
  int i=0;
  int j=0;
  clock_t begin,end;

  const mmi64_addr_t user_addr[] = {2, 1, 0};
  mmi64_module_t * user_module;
  
  const mmi64_addr_t ctrl_addr[] = {2, 1, 1};
  mmi64_module_t * ctrl_module;
  
  int mh_status = profpga_set_message_handler(message_handler);
  
  if (mh_status!=0) {
    printf("ERROR: Failed to install message handler (code %d)\n", mh_status);
    return mh_status;
  }
  
  // connect to system
  printf(NOW("Open connection to profpga platform...\n"));
  
  status = profpga_open (&profpga, cfgfilename);
  if (status!=E_PROFPGA_OK) { // cannot use NOW() macro because required MMI-64 domain handle has not been initialized
    printf("ERROR: Failed connect to PROFPGA system (%s)\n", profpga_strerror(status));
    return status;
  }
  
#ifdef HDL_SIM
  // for HDL simulation: perform configuration as done by profpga_run --up
  printf(NOW("Bring up system.\n"));
  status = profpga_up(profpga);
  CHECK(status);
#endif
  
  // scan for MMI-64 modules
  printf(NOW("Scan hardware...\n"));
  status = mmi64_identify_scan(profpga->mmi64_domain);
  CHECK(status);
  
  // print scan results
  status = mmi64_info_print(profpga->mmi64_domain);
  CHECK(status);
  
  // find user module
  status = mmi64_identify_by_address(profpga->mmi64_domain, user_addr, &user_module);
  CHECK(status);
  if (user_module==NULL) {
    printf("ERROR: Failed to identify user module. \n");
    return -1;
  }
  
  status = mmi64_identify_by_address(profpga->mmi64_domain, ctrl_addr, &ctrl_module);
  if (status || !ctrl_module) {
    printf(NOW("Failed to identify clocksync module!\n"));
  } else {
    uint16_t data16 = 12;
    printf(NOW("Setting up SYNC delay...\n"));
    status = mmi64_regif_write_16_ack(ctrl_module, REGID_USERCTRL_SYNC1_DELAY, 1, &data16);
    printf(NOW("Result = %d\n"), status);
  }
  
  // trigger SYNC events to release reset(1...4)
  printf(NOW("Release reset(1)\n"));
  status = profpga_acm_sync_event(profpga, 0, 1, EVENTID_RESET_LO);
  CHECK(status);
  
  printf(NOW("Release reset(2)\n"));
  status = profpga_acm_sync_event(profpga, 0, 2, EVENTID_RESET_LO);
  CHECK(status);
  
  printf(NOW("Release reset(3)\n"));
  status = profpga_acm_sync_event(profpga, 0, 3, EVENTID_RESET_LO);
  CHECK(status);
  
  printf(NOW("Release reset(4)\n"));
  status = profpga_acm_sync_event(profpga, 0, 4, EVENTID_RESET_LO);
  CHECK(status);
  
#ifdef HDL_SIM
  int i;
  // HDL simulation: non-interactive, lower divider values
  // Initialize registers
  for (i=0;i<8;i++) data[i] = 10;
  printf(NOW("Initialize divider registers\n"));
  status = mmi64_regif_write_32_ack(user_module, 0, 8, data);
  CHECK(status);
#else
	strcpy(inputfilename,"input.txt");

	printf("Using input file %s\n", inputfilename);
	fp = fopen(inputfilename, "r");
	//check if file exists
	if (fp == NULL){
		printf("file does not exists %s", inputfilename);
		return -1;
	}

	strcpy(inputfilename,"readdata.txt");

	printf("File with instructions to read the memory content %s\n", inputfilename);
	frdata = fopen(inputfilename, "r");
	//check if file exists
	if (fp == NULL){
		printf("file does not exists %s", inputfilename);
		return -1;
	}	

	strcpy(inputfilename,"output.txt");

	printf("Using output file %s\n", inputfilename);
	fout = fopen(inputfilename, "w");
	//check if file exists
	if (fout == NULL){
		printf("file does not exists %s", inputfilename);
		return -1;
	}
	
	printf("Type ENTER to send all the request\n");
	getchar();
	
	data[0]=0; 
	status = mmi64_regif_write_64_ack(user_module, 15, 1, data); // Others clause: Sending 0 to every request and to start_cu
	CHECK(status);	
	
	while( fscanf(fp,"%s",line)==1){	

		data[0]=convFromBin(line,42); // ctrl(0) & request_in(0)	
		j++;
		status = mmi64_regif_write_64_ack(user_module, 0, 1, data);
		CHECK(status);
		
		if ( j == 81 ){
			printf("Sent all the data. Type ENTER to continue \n");
			getchar();
		}	
	}

	printf("Sent all the instructions. Type ENTER to start the algo \n");
	getchar();

	data[0]=1; // Sending 1 to start_cu and starting the algo
	status = mmi64_regif_write_64_ack(user_module, 1, 1, data);
	CHECK(status);	
	
	begin = clock();
	
	//Waiting the end of the algo
	rdata=0;
	i=0;
	while(rdata==0 && i<50){
		i++;
		status = mmi64_regif_read_64(user_module, 1, 1, &rdata);
		CHECK(status);
	}
	end = clock();
	printf("Time elapsed: %f \n",(double)(end - begin) / CLOCKS_PER_SEC);
	printf("Cycle %d. END CU: %lld \n",i,(long long)rdata);
	i=0;
	//Reading content of the pillars
	while( fscanf(frdata,"%s",line)==1){	
	
		data[0]=convFromBin(line,42); // ctrl(0) & request_in(0)	
		status = mmi64_regif_write_64_ack(user_module, 0, 1, data);
		CHECK(status);

		status = mmi64_regif_read_64(user_module, 0, 1, &rdata); //request_out(0)
		CHECK(status);	
		//Printing on terminal the output 
		//For the LIM the actual data are the 26 LSBs -> convert the number seen on the terminal in binary, take the 26 left bits and convert them in decimal
		//It's possible to fprintf on fout
		printf("Read %d: %lld \n",i,(long long)rdata);
		
		i++;
	}

	fclose(fp);

	
	printf("Type ENTER to close the connection\n");
	getchar();


#endif  
  
  printf(NOW("Done. Closing connection...\n"));
  
  return profpga_close(&profpga);
}

#ifndef HDL_SIM
int main(int argc, char * argv[])
{
  if (argc!=2) {
    printf("Wrong arguments! Usage:\n    mmi64basic_test [CONFIGFILE.cfg]\n");
    return -1;
  }
  printf("Using configuration file %s\n", argv[1]);
  cfgfilename = argv[1];
  return  mmi64_main(argc, argv);
}
#endif

