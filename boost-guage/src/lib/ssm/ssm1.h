struct ssm1_operation {
    int instruction;
    char address[4];
    char response[10];
    int status;
};


// Choose the name from boards.h that matches your setup
#ifndef VEHICLE
  #define VEHICLE SUBARU_WRX_SEDAN_1995_AUS
#endif
