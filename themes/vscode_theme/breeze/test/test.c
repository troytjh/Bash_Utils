// Troy Hoover
#include "msp_adc.h"

void ADC_TC_INIT(DIO_PORT *P)
{
    // Alternative, A22
    switch (P->type) {
    case EVEN:
        P->Px.E->SEL1 |= BIT2;
        P->Px.E->SEL0 |= BIT2;
        break;
    case ODD:
        P->Px.O->SEL1 |= BIT2;
        P->Px.O->SEL0 |= BIT2;
        break;
    }

    while(REF_A->CTL0 & REF_A_CTL0_GENBUSY);
    REF_A->CTL0 |= REF_A_CTL0_VSEL_3 | REF_A_CTL0_ON;
    REF_A->CTL0 &= ~REF_A_CTL0_TCOFF;
    Ref_T30 = TLV->ADC14_REF2P5V_TS30C/4;
    Ref_T85 = TLV->ADC14_REF2P5V_TS85C/4;

    ADC14->CTL0 = ADC14_CTL0_SHT0_6 | ADC14_CTL0_SHP | ADC14_CTL0_ON;
    ADC14->CTL1 = ADC14_CTL1_RES_2;
    ADC14->CTL1 |= ADC14_CTL1_TCMAP;
    ADC14->MCTL[0] = ADC14_MCTLN_VRSEL_1 | ADC14_MCTLN_INCH_22;
}

void ADC_TC_READ()
{
    ADC14->CTL0 |= ADC14_CTL0_ENC |ADC14_CTL0_SC;
    while((ADC14->CTL0 & ADC14_CTL0_BUSY)!=0);
    adc_raw=ADC14->MEM[0];
}

void ADC_TC_PRINT(char T)
{
    char str[16];
    sprintf(str, "NADC: %u\0", adc_raw);
    //LCD_DISP(str, 1, 0);

    double TempDegC = (((float)adc_raw-Ref_T30)*55)/(Ref_T85-Ref_T30)+30.0;
    switch (T) {
    case 'C':
        sprintf(str, "%0.1f\xb0\C\0", TempDegC);
        //LCD_DISP(str,2,0);
        break;
    case 'F':
        float TempDegF = (TempDegC*1.8)+32;
        sprintf(str, "%0.1f\xb0\F\0", TempDegF);
        //LCD_DISP(str,2,0);
        break;
    }
}