#include <map>
#include "../ssm1.h"
using namespace std;

struct ssm1_operation {
    char *address[4];
    char *response[10];
    int instruction;
    int status;
};

map<string, ssm1_operation> vehicle_operations;