#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void r_select3(char r[20], char c[20] );
void r_select4(char r[20], char c[20] );
void dec_turn_bin(int n, char c[20] );
void hex_turn_bin(char h, char c[20] );
char* itobs(int n, char *ps);
int main(void)
{
    FILE *fPtr;
    FILE *file;
    char c1[20], c2[20], c3[20], c4[20]; 
    char d2[20], d3[20], d4[20], d5[20]; 
    char h1,h2,h3,h4;
    int n1;
    int radix =2;
    int n = 2 ;
    char s[8 * sizeof(n) + 1];
    int count = 0;
    
    fPtr = fopen("opcode.txt", "r");
    if (!fPtr) {
        printf("檔案開啟失敗...\n");
        system("pause");
        exit(1);
    }
    file = fopen("opcode.coe", "w");
    if(file == NULL) {
    printf("Cannot open file");
    exit(0);
    }
    fprintf(file, "memory_initialization_radix=%d;\n", radix);
    fprintf(file, "memory_initialization_vector=\n");
    fscanf(fPtr, "%s", c1);
while(!feof(fPtr)) {                

////////////NULL////////////////////////////
    if( strcmp(c1,"NULL") == 0){  
    fprintf(file,"%s,\n", "0000000000000000");
    count = count +1;
    }
////////////ADD////////////////////////////
    else if( strcmp(c1,"ADD") == 0){
    fscanf(fPtr, "%s%s%s", c2, c3, c4);
    r_select3(c2,d2);   
    r_select3(c3,d3);
    r_select3(c4,d4);    
    fprintf(file,"%s%s%s%s%s,\n", "0001",d2,d3,d4,"000");
    count = count +1;
    }
////////////SUB////////////////////////////
    else if( strcmp(c1,"SUB") == 0){
    fscanf(fPtr, "%s%s%s", c2, c3, c4);
    r_select3(c2,d2);   
    r_select3(c3,d3);
    r_select3(c4,d4);    
    fprintf(file,"%s%s%s%s%s,\n", "0001",d2,d3,d4,"001");
    count = count +1;
    }    
////////////MUXA////////////////////////////
    else if( strcmp(c1,"MUXA") == 0){
    fscanf(fPtr, "%s%s%s", c2, c3, c4);
    r_select3(c2,d2);   
    r_select3(c3,d3);
    r_select3(c4,d4);    
    fprintf(file,"%s%s%s%s%s,\n", "0001",d2,d3,d4,"010");
    count = count +1;
    }    
////////////MUXB////////////////////////////
    else if( strcmp(c1,"MUXB") == 0){
    fscanf(fPtr, "%s%s%s", c2, c3, c4);
    r_select3(c2,d2);   
    r_select3(c3,d3);
    r_select3(c4,d4);    
    fprintf(file,"%s%s%s%s%s,\n", "0001",d2,d3,d4,"011");
    count = count +1;
    }   
////////////BTD////////////////////////////
    else if( strcmp(c1,"BTD") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select3(c2,d2);   
    r_select3(c3,d3);    
    fprintf(file,"%s%s%s%s%s,\n", "0001",d2,d3,d3,"100");
    count = count +1;
    }    
////////////INC////////////////////////////
    else if( strcmp(c1,"INC") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select3(c2,d2);   
    r_select3(c3,d3); 
    fprintf(file,"%s%s%s%s%s,\n", "0001",d2,d3,d3,"101");
    count = count +1;
    }       
////////////DEC////////////////////////////
    else if( strcmp(c1,"DEC") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select3(c2,d2);   
    r_select3(c3,d3); 
    fprintf(file,"%s%s%s%s%s,\n", "0001",d2,d3,d3,"110");
    count = count +1;
    }   
////////////CLR////////////////////////////
    else if( strcmp(c1,"CLR") == 0){
    fscanf(fPtr, "%s", c2);
    r_select3(c2,d2);   
    fprintf(file,"%s%s%s%s%s,\n", "0001",d2,d2,d2,"111");
    count = count +1;
    }  
////////////NOT////////////////////////////
    else if( strcmp(c1,"NOT") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select3(c2,d2);   
    r_select3(c3,d3); 
    fprintf(file,"%s%s%s%s%s,\n", "0010",d2,d3,d3,"000");
    count = count +1;
    }   
////////////AND////////////////////////////
    else if( strcmp(c1,"AND") == 0){
    fscanf(fPtr, "%s%s%s", c2, c3, c4);
    r_select3(c2,d2);   
    r_select3(c3,d3);
    r_select3(c4,d4);    
    fprintf(file,"%s%s%s%s%s,\n", "0010",d2,d3,d4,"001");
    count = count +1;
    }  
////////////NAND////////////////////////////
    else if( strcmp(c1,"NAND") == 0){
    fscanf(fPtr, "%s%s%s", c2, c3, c4);
    r_select3(c2,d2);   
    r_select3(c3,d3);
    r_select3(c4,d4);    
    fprintf(file,"%s%s%s%s%s,\n", "0010",d2,d3,d4,"010");
    count = count +1;
    }  
////////////OR////////////////////////////
    else if( strcmp(c1,"OR") == 0){
    fscanf(fPtr, "%s%s%s", c2, c3, c4);
    r_select3(c2,d2);   
    r_select3(c3,d3);
    r_select3(c4,d4);    
    fprintf(file,"%s%s%s%s%s,\n", "0010",d2,d3,d4,"011");
    count = count +1;
    }  
////////////NOR////////////////////////////
    else if( strcmp(c1,"NOR") == 0){
    fscanf(fPtr, "%s%s%s", c2, c3, c4);
    r_select3(c2,d2);   
    r_select3(c3,d3);
    r_select3(c4,d4);    
    fprintf(file,"%s%s%s%s%s,\n", "0010",d2,d3,d4,"100");
    count = count +1;
    }     
////////////XOR////////////////////////////
    else if( strcmp(c1,"XOR") == 0){
    fscanf(fPtr, "%s%s%s", c2, c3, c4);
    r_select3(c2,d2);   
    r_select3(c3,d3);
    r_select3(c4,d4);    
    fprintf(file,"%s%s%s%s%s,\n", "0010",d2,d3,d4,"101");
    count = count +1;
    }     
////////////XNOR////////////////////////////
    else if( strcmp(c1,"XNOR") == 0){
    fscanf(fPtr, "%s%s%s", c2, c3, c4);
    r_select3(c2,d2);   
    r_select3(c3,d3);
    r_select3(c4,d4);    
    fprintf(file,"%s%s%s%s%s,\n", "0010",d2,d3,d4,"110");
    count = count +1;
    }  
////////////EQ////////////////////////////
    else if( strcmp(c1,"EQ") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select3(c2,d2);   
    r_select3(c3,d3); 
    fprintf(file,"%s%s%s%s%s,\n", "0010","000",d2,d3,"111");
    count = count +1;
    }   
////////////NE////////////////////////////
    else if( strcmp(c1,"NE") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select3(c2,d2);   
    r_select3(c3,d3); 
    fprintf(file,"%s%s%s%s%s,\n", "0010","001",d2,d3,"111");
    count = count +1;
    }    
////////////GT////////////////////////////
    else if( strcmp(c1,"GT") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select3(c2,d2);   
    r_select3(c3,d3); 
    fprintf(file,"%s%s%s%s%s,\n", "0010","010",d2,d3,"111");
    count = count +1;
    }     
////////////LE////////////////////////////
    else if( strcmp(c1,"LE") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select3(c2,d2);   
    r_select3(c3,d3); 
    fprintf(file,"%s%s%s%s%s,\n", "0010","011",d2,d3,"111");
    count = count +1;
    }     
////////////LT////////////////////////////
    else if( strcmp(c1,"LT") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select3(c2,d2);   
    r_select3(c3,d3); 
    fprintf(file,"%s%s%s%s%s,\n", "0010","100",d2,d3,"111");
    count = count +1;
    }     
////////////GE////////////////////////////
    else if( strcmp(c1,"GE") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select3(c2,d2);   
    r_select3(c3,d3); 
    fprintf(file,"%s%s%s%s%s,\n", "0010","101",d2,d3,"111");
    count = count +1;
    }     
////////////SHL////////////////////////////
    else if( strcmp(c1,"SHL") == 0){
    fscanf(fPtr, "%s%d", c2, &n1);
    r_select4(c2,d2);    
    dec_turn_bin(n1,d3);
    fprintf(file,"%s%s%s%s,\n", "0011",d2,d3,"0000");
    count = count +1;
    }
////////////SHR////////////////////////////
    else if( strcmp(c1,"SHR") == 0){
    fscanf(fPtr, "%s%d", c2, &n1);
    r_select4(c2,d2);    
    dec_turn_bin(n1,d3);
    fprintf(file,"%s%s%s%s,\n", "0011",d2,d3,"0001");
    count = count +1;
    }
////////////SCL////////////////////////////
    else if( strcmp(c1,"SCL") == 0){
    fscanf(fPtr, "%s%d", c2, &n1);
    r_select4(c2,d2);    
    dec_turn_bin(n1,d3);
    fprintf(file,"%s%s%s%s,\n", "0011",d2,d3,"0010");
    count = count +1;
    }
////////////SCR////////////////////////////
    else if( strcmp(c1,"SHR") == 0){
    fscanf(fPtr, "%s%d", c2, &n1);
    r_select4(c2,d2);    
    dec_turn_bin(n1,d3);
    fprintf(file,"%s%s%s%s,\n", "0011",d2,d3,"0011");
    count = count +1;
    }
////////////SAL////////////////////////////
    else if( strcmp(c1,"SAL") == 0){
    fscanf(fPtr, "%s", c2);
    r_select4(c2,d2);    
    fprintf(file,"%s%s%s%s,\n", "0011",d2,d2,"0100");
    count = count +1;
    } 
////////////SAR////////////////////////////
    else if( strcmp(c1,"SAR") == 0){
    fscanf(fPtr, "%s", c2);
    r_select4(c2,d2);    
    fprintf(file,"%s%s%s%s,\n", "0011",d2,d2,"0101");
    count = count +1;
    } 
////////////ROL////////////////////////////
    else if( strcmp(c1,"ROL") == 0){
    fscanf(fPtr, "%s%d", c2, &n1);
    r_select4(c2,d2);    
    dec_turn_bin(n1,d3);
    fprintf(file,"%s%s%s%s,\n", "0011",d2,d3,"0110");
    count = count +1;
    }
////////////ROR////////////////////////////
    else if( strcmp(c1,"ROR") == 0){
    fscanf(fPtr, "%s%d", c2, &n1);
    r_select4(c2,d2);    
    dec_turn_bin(n1,d3);
    fprintf(file,"%s%s%s%s,\n", "0011",d2,d3,"0111");
    count = count +1;
    }  
////////////RCL////////////////////////////
    else if( strcmp(c1,"RCL") == 0){
    fscanf(fPtr, "%s%d", c2, &n1);
    r_select4(c2,d2);    
    dec_turn_bin(n1,d3);
    fprintf(file,"%s%s%s%s,\n", "0011",d2,d3,"1000");
    count = count +1;
    }
////////////RCR////////////////////////////
    else if( strcmp(c1,"RCR") == 0){
    fscanf(fPtr, "%s%d", c2, &n1);
    r_select4(c2,d2);    
    dec_turn_bin(n1,d3);
    fprintf(file,"%s%s%s%s,\n", "0011",d2,d3,"1001");
    count = count +1;
    }  
////////////SETCY////////////////////////////
    else if( strcmp(c1,"SETCY") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","0000");
    count = count +1;
    }  
////////////CLRCY////////////////////////////
    else if( strcmp(c1,"CLRCY") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","0001");
    count = count +1;
    }  
////////////SETSF////////////////////////////
    else if( strcmp(c1,"SETSF") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","0010");
    count = count +1;
    }  
////////////CLRSF////////////////////////////
    else if( strcmp(c1,"CLRSF") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","0011");
    count = count +1;
    }  
////////////SETEQ////////////////////////////
    else if( strcmp(c1,"SETEQ") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","0100");
    count = count +1;
    }  
////////////CLREQ////////////////////////////
    else if( strcmp(c1,"CLREQ") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","0101");
    count = count +1;
    }  
////////////SETBT////////////////////////////
    else if( strcmp(c1,"SETBT") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","0110");
    count = count +1;
    }  
////////////CLRBT////////////////////////////
    else if( strcmp(c1,"CLRBT") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","0111");
    count = count +1;
    }  
////////////SETST////////////////////////////
    else if( strcmp(c1,"SETST") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","1000");
    count = count +1;
    }  
////////////CLRST////////////////////////////
    else if( strcmp(c1,"CLRST") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","1001");
    count = count +1;
    }    
////////////SETIEN////////////////////////////
    else if( strcmp(c1,"SETIEN") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","1010");
    count = count +1;
    }  
////////////CLRIEN////////////////////////////
    else if( strcmp(c1,"CLRIEN") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","1011");
    count = count +1;
    }  
////////////SETIT1////////////////////////////
    else if( strcmp(c1,"SETIT1") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","1100");
    count = count +1;
    }  
////////////CLRIT1////////////////////////////
    else if( strcmp(c1,"CLRIT1") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","1101");
    count = count +1;
    }      
////////////SETIT0////////////////////////////
    else if( strcmp(c1,"SETIT0") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","1110");
    count = count +1;
    }  
////////////CLRIT0////////////////////////////
    else if( strcmp(c1,"CLRIT0") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000000","1111");
    count = count +1;
    }     
////////////SETITR////////////////////////////
    else if( strcmp(c1,"SETITR") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000001","0000");
    count = count +1;
    }  
////////////CLRITR////////////////////////////
    else if( strcmp(c1,"CLRITR") == 0){
    fprintf(file,"%s%s%s,\n", "0100","00000001","0001");
    count = count +1;
    }   
////////////LOAD////////////////////////////
    else if( strcmp(c1,"LOAD") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select4(c2,d2);    
    r_select4(c3,d3);
    fprintf(file,"%s%s%s%s,\n", "0101",d2,d3,"0000");
    count = count +1;
    }
////////////STORE////////////////////////////
    else if( strcmp(c1,"STORE") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select4(c2,d2);    
    r_select4(c3,d3);
    fprintf(file,"%s%s%s%s,\n", "0101",d2,d3,"1111");
    count = count +1;
    }
////////////SET/////////////////////////////
    else if( strcmp(c1,"SET") == 0){
    fscanf(fPtr, "%s", c2);
    r_select4(c2,d2);    
    fprintf(file,"%s%s%s,\n", "0110",d2,"00000000");
    count = count +1;
    }
////////////MOVE////////////////////////////
    else if( strcmp(c1,"MOVE") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select4(c2,d2);    
    r_select4(c3,d3);
    fprintf(file,"%s%s%s%s,\n", "0111",d2,d3,"0000");
    count = count +1;
    }    
////////////MOVEIT0////////////////////////////
    else if( strcmp(c1,"MOVEIT0") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select4(c2,d2);    
    r_select4(c3,d3);
    fprintf(file,"%s%s%s%s,\n", "0111",d2,d3,"0001");
    count = count +1;
    }    
////////////MOVEIT1////////////////////////////
    else if( strcmp(c1,"MOVEIT1") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select4(c2,d2);    
    r_select4(c3,d3);
    fprintf(file,"%s%s%s%s,\n", "0111",d2,d3,"0010");
    count = count +1;
    } 
////////////MOVEIT1////////////////////////////
    else if( strcmp(c1,"MOVEITR") == 0){
    fscanf(fPtr, "%s", c2);
    r_select4(c2,d2);    
    fprintf(file,"%s%s%s,\n", "01110000",d2,"0011");
    count = count +1;
    }    
////////////MOVEFS////////////////////////////
    else if( strcmp(c1,"MOVEFS") == 0){
    fprintf(file,"%s%s,\n", "011100000000","0100");
    count = count +1;
    }    
////////////MOVEFL////////////////////////////
    else if( strcmp(c1,"MOVEFL") == 0){
    fprintf(file,"%s%s,\n", "011100000000","0101");
    count = count +1;
    }    
////////////PUSH////////////////////////////
    else if( strcmp(c1,"PUSH") == 0){
    fscanf(fPtr, "%s", c2);
    r_select4(c2,d2);    
    fprintf(file,"%s%s%s,\n", "1000",d2,"00000000");
    count = count +1;
    }    
////////////POP////////////////////////////
    else if( strcmp(c1,"POP") == 0){
    fscanf(fPtr, "%s", c2);
    r_select4(c2,d2);    
    fprintf(file,"%s%s%s,\n", "1000",d2,"11111111");
    count = count +1;
    }        
///////////JZ//////////////////////////////
    else if( strcmp(c1,"JZ") == 0){
    fscanf(fPtr, "%s%s%d", c2,c3,&n1);
    r_select3(c2,d2);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1001",d2,d3, itobs(n,s));
    count = count +1;
    }    
///////////JNZ//////////////////////////////
    else if( strcmp(c1,"JNZ") == 0){
    fscanf(fPtr, "%s%s%d", c2,c3,&n1);
    r_select3(c2,d2);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1010",d2,d3, itobs(n,s));
    count = count +1;
    }    
///////////JMP//////////////////////////////
    else if( strcmp(c1,"JMP") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1011","000",d3, itobs(n,s));
    count = count +1;
    }    
///////////JCY//////////////////////////////
    else if( strcmp(c1,"JCY") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1011","001",d3, itobs(n,s));
    count = count +1;
    }    
///////////JCNY//////////////////////////////
    else if( strcmp(c1,"JNCY") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1011","010",d3, itobs(n,s));
    count = count +1;
    }  
///////////JSF//////////////////////////////
    else if( strcmp(c1,"JSF") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1011","011",d3, itobs(n,s));
    count = count +1;
    }  
///////////JNSF//////////////////////////////
    else if( strcmp(c1,"JNSF") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1011","100",d3, itobs(n,s));
    count = count +1;
    }  
///////////JEQ//////////////////////////////
    else if( strcmp(c1,"JEQ") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1011","101",d3, itobs(n,s));
    count = count +1;
    }  
///////////JNEQ//////////////////////////////
    else if( strcmp(c1,"JNEQ") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1011","110",d3, itobs(n,s));
    count = count +1;
    }  
///////////JBT//////////////////////////////
    else if( strcmp(c1,"JBT") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1011","111",d3, itobs(n,s));
    count = count +1;
    }  
///////////JNBT//////////////////////////////
    else if( strcmp(c1,"JNBT") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1100","000",d3, itobs(n,s));
    count = count +1;
    }  
///////////JST//////////////////////////////
    else if( strcmp(c1,"JST") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1100","001",d3, itobs(n,s));
    count = count +1;
    }  
///////////JNST//////////////////////////////
    else if( strcmp(c1,"JNST") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1100","010",d3, itobs(n,s));
    count = count +1;
    }  
///////////JIT1//////////////////////////////
    else if( strcmp(c1,"JIT1") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1100","011",d3, itobs(n,s));
    count = count +1;
    }  
///////////JNIT1//////////////////////////////
    else if( strcmp(c1,"JNIT1") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1100","100",d3, itobs(n,s));
    count = count +1;
    }  
///////////JIT0//////////////////////////////
    else if( strcmp(c1,"JIT0") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1100","101",d3, itobs(n,s));
    count = count +1;
    }  
///////////JNIT0//////////////////////////////
    else if( strcmp(c1,"JNIT0") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1100","110",d3, itobs(n,s));
    count = count +1;
    }  
///////////JIEN//////////////////////////////
    else if( strcmp(c1,"JIEN") == 0){
    fscanf(fPtr, "%s%d", c3,&n1);
    if(strcmp(c3,"-") == 0){strcpy(d3,"1");}    
    else if(strcmp(c3,"+") == 0){strcpy(d3,"0");} 
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    } 
    n = n1;
    fprintf(file,"%s%s%s%s,\n", "1100","111",d3, itobs(n,s));
    count = count +1;
    }  
////////////IN////////////////////////////
    else if( strcmp(c1,"IN") == 0){
    fscanf(fPtr, "%s", c2);
    r_select4(c2,d2);    
    fprintf(file,"%s%s%s%s,\n", "1101","0000",d2,"0000");
    count = count +1;
    }        
////////////OUT////////////////////////////
    else if( strcmp(c1,"OUT") == 0){
    fscanf(fPtr, "%s%s", c2, c3);
    r_select4(c2,d2);   
    r_select4(c3,d3); 
    fprintf(file,"%s%s%s%s,\n", "1101",d2,d3,"1111");
    count = count +1;
    }     
////////////CALL///////////////////////////   
    else if( strcmp(c1,"CALL") == 0){
    fscanf(fPtr, "%s", c2);
    h1 = c2[0];
    h2 = c2[1];
    h3 = c2[2];
    hex_turn_bin(h1,d2);   
    hex_turn_bin(h2,d3); 
    hex_turn_bin(h3,d4); 
    fprintf(file,"%s%s%s%s,\n", "1110",d2,d3,d4);
    count = count +1;
    }      
    
////////////RET////////////////////////////
    else if( strcmp(c1,"RET") == 0){
    fprintf(file,"%s,\n", "1110111111111111");
    count = count +1;
    }     
////////////HALT////////////////////////////
    else if( strcmp(c1,"HALT") == 0){
    fprintf(file,"%s,\n", "1111111111111111");
    count = count +1;
    }     
////////////////////////////////////////////
////////////HEX///////////////////////////   
    else if( strcmp(c1,"H") == 0){
    fscanf(fPtr, "%s", c2);
    h1 = c2[0];
    h2 = c2[1];
    h3 = c2[2];
    h4 = c2[3];
    hex_turn_bin(h1,d2);   
    hex_turn_bin(h2,d3); 
    hex_turn_bin(h3,d4); 
    hex_turn_bin(h4,d5); 
    fprintf(file,"%s%s%s%s,\n",d2,d3,d4,d5);
    count = count +1;
    }   
////////////END////////////////////////////
    else if( strcmp(c1,"END") == 0){
    }     
////////////ORG////////////////////////////
    else if( strcmp(c1,"ORG") == 0){
    fscanf(fPtr, "%x", &n1);    
      while(count != n1){
         fprintf(file,"%s,\n","0000000000000000");
         if(count > n1){
              printf("程式錯誤，請檢查。\n");
              system("pause");
         }
         count = count +1;
         if(count == 4096)
         break;         
      }
      
    }    
//////////////////////////////////////////
////////////WRONG////////////////////////////
    else{
    printf("程式錯誤，請檢查。\n");
    system("pause");
    }     
//////////////////////////////////////////
    fscanf(fPtr, "%s", c1);
}
    if(count > 4096)
    {
    printf("程式超出長度，請檢查\n");
    system("pause"); 
    }
      while(count < 4096){
         fprintf(file,"%s,\n","0000000000000000");
         count = count +1;       
      }  
    fclose(file);
    fclose(fPtr);
    printf("程式組譯完成\n");
    system("pause");
    return 0;
}

void r_select3(char r[20], char c[20] )
{
      if(strcmp(r,"R0") == 0){strcpy(c,"000");}
      if(strcmp(r,"R1") == 0){strcpy(c,"001");}
      if(strcmp(r,"R2") == 0){strcpy(c,"010");}
      if(strcmp(r,"R3") == 0){strcpy(c,"011");} 
      if(strcmp(r,"R4") == 0){strcpy(c,"100");}
      if(strcmp(r,"R5") == 0){strcpy(c,"101");}
      if(strcmp(r,"R6") == 0){strcpy(c,"110");}
      if(strcmp(r,"R7") == 0){strcpy(c,"111");}
}     

void r_select4(char r[20], char c[20] )
{
      if(strcmp(r,"R0") == 0){strcpy(c,"0000");}
      if(strcmp(r,"R1") == 0){strcpy(c,"0001");}
      if(strcmp(r,"R2") == 0){strcpy(c,"0010");}
      if(strcmp(r,"R3") == 0){strcpy(c,"0011");} 
      if(strcmp(r,"R4") == 0){strcpy(c,"0100");}
      if(strcmp(r,"R5") == 0){strcpy(c,"0101");}
      if(strcmp(r,"R6") == 0){strcpy(c,"0110");}
      if(strcmp(r,"R7") == 0){strcpy(c,"0111");}
      if(strcmp(r,"R8") == 0){strcpy(c,"1000");}
      if(strcmp(r,"R9") == 0){strcpy(c,"1001");}
      if(strcmp(r,"R10") == 0){strcpy(c,"1010");}
      if(strcmp(r,"R11") == 0){strcpy(c,"1011");}
      if(strcmp(r,"R12") == 0){strcpy(c,"1100");}
      if(strcmp(r,"R13") == 0){strcpy(c,"1101");}
      if(strcmp(r,"R14") == 0){strcpy(c,"1110");}
      if(strcmp(r,"R15") == 0){strcpy(c,"1111");}
}  
   
void dec_turn_bin(int n, char c[20] )
{
      switch(n){
      case 0: strcpy(c,"0000"); break;
      case 1: strcpy(c,"0001"); break;
      case 2: strcpy(c,"0010"); break;
      case 3: strcpy(c,"0011"); break;
      case 4: strcpy(c,"0100"); break;
      case 5: strcpy(c,"0101"); break;
      case 6: strcpy(c,"0110"); break;
      case 7: strcpy(c,"0111"); break;
      case 8: strcpy(c,"1000"); break;
      case 9: strcpy(c,"1001"); break;
      case 10: strcpy(c,"1010"); break;
      case 11: strcpy(c,"1011"); break;
      case 12: strcpy(c,"1100"); break;
      case 13: strcpy(c,"1101"); break;
      case 14: strcpy(c,"1110"); break;
      case 15: strcpy(c,"1111"); break;
      default : strcpy(c,"0000"); break;
      }
}     

char* itobs(int n, char *ps) {
      int size = 2 * sizeof(n);
      int i = size -1;
  
  while(i+1) {
        ps[i--] = (1 & n) + '0';
        n >>= 1;
   }
  
       ps[size] = '\0';
       
        return ps; 
}

void hex_turn_bin(char h, char c[20] )
{
      if(h == '0'){strcpy(c,"0000");}
      if(h == '1'){strcpy(c,"0001");}
      if(h == '2'){strcpy(c,"0010");}
      if(h == '3'){strcpy(c,"0011");} 
      if(h == '4'){strcpy(c,"0100");}
      if(h == '5'){strcpy(c,"0101");}
      if(h == '6'){strcpy(c,"0110");}
      if(h == '7'){strcpy(c,"0111");}
      if(h == '8'){strcpy(c,"1000");}
      if(h == '9'){strcpy(c,"1001");}
      if(h == 'A'){strcpy(c,"1010");}
      if(h == 'B'){strcpy(c,"1011");}
      if(h == 'C'){strcpy(c,"1100");}
      if(h == 'D'){strcpy(c,"1101");}
      if(h == 'E'){strcpy(c,"1110");}
      if(h == 'F'){strcpy(c,"1111");}
}  
