#ifndef PXSET_H_
#define PXSET_H_

#include "msp.h"

// Port alias
typedef enum {
    Px1,
    Px2,
    Px3,
    Px4,
    Px5,
    Px6,
    Px7,
    Px8,
    Px9,
    Px10,
} PORT_TYPE;

// differentiate port type (inside function)
typedef enum {
    EVEN,
    ODD,
} EOO;

// store struct pointer to port address
typedef struct {
    PORT_TYPE port;
    EOO type;
    union {
        DIO_PORT_Even_Interruptable_Type *E;
        DIO_PORT_Odd_Interruptable_Type *O;
    } Px;
} DIO_PORT;

// use port alias to assign physical port address to struct
void PxSET(DIO_PORT*,int);

#endif /* PXSET_H_ */