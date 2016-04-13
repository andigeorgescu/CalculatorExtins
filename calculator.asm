include emu8086.inc   ; includere biblioteca emu8086  

START:        
    ; initializare registrii 
    MOV AX,0h    
    MOV BX,0h      
    MOV CX,0h     
    MOV DX,0h   
    
    ; generare interfata cu operatiile posibile + posibilitatea de inchidere a programului                
    GOTOXY 1,0     
    PRINT '======================= CALCULATOR FUNCTII SPECIALE ======================='                    
    GOTOXY 1,2                        
    PRINT '1-Iesire'  
    GOTOXY 1,3  
    PRINT '2-Adunare'                                 
    GOTOXY 1,4  
    PRINT '3-Scadere'  
    GOTOXY 1,5  
    PRINT '4-Inmultire'  
    GOTOXY 1,6  
    PRINT '5-DIV'  
    GOTOXY 1,7  
    PRINT '6-SI'  
    GOTOXY 1,8  
    PRINT '7-SAU'  
    GOTOXY 1,9  
    PRINT '8-XOR'
   
       
    GOTOXY 3,12                          ;  pozitionare cursor
    PRINT 'Introduceti primul numar:  '  ;  afisare mesaj 
    CALL SCAN_NUM                        ; apelare instructiune citire  
    MOV [0200h],CX                       ; retin la adresa [0200h] continutul registrului CX ce contine valoarea citita de la tastatura 
    MOV AX,CX                              
    GOTOXY 3,13                          ; poz cursor 
    
       
    PRINT 'Introduceti al doilea numar:  '; afisare mesaj  
    CALL SCAN_NUM                        ; apelare instructiune citire 
    MOV [0202h],CX                       ; retin la adresa [0202h] continutul registrului CX ce contine valoarea citita de la tastatura  
    MOV CX,0h                            
               
    GOTOXY 2,15            ;  pozitionare cursor   
    PRINT 'Alegeti o operatie: '  ;  afisare mesaj  
    CHOOSE_FALSE_A:  CALL SCAN_NUM   ; daca operatia este invalida se reapeleaza instructiunea de citire
     
    ;executie conditionala in functie de optiunea aleasa(IESIRE, ADUNARE, SCADERE, INMULTIRE, DIV, SI, SAU, XOR)
    GOTOXY 1,17                    
    CMP CX,1h       
    JE IESIRE       
    CMP CX,2h       
    JE ADUNARE      
    CMP CX,3h       
    JE SCADERE       
    CMP CX,4h       
    JE INMULTIRE    
    CMP CX,5h       
    JE IMPARTIRE      
    CMP CX,6h       
    JE SI_LOGIC      
    CMP CX,7h       
    JE SAU_LOGIC      
    CMP CX,8h         
    JE XOR_LOGIC   
    
    JMP FALSE_A       
        
IESIRE:                                  
    JMP FINAL            
                     
           
ADUNARE:                               
    CALL ADUNARE_fin    ; calcul efectiv 
    JMP REZULTAT        ; trimit rezultatul catre o instructiune de generare a interfetei rezultat
ADUNARE_fin:                                   
    PRINT 'ADUNARE '    ; afisare operatia executata 
    ADC AX,[0202h]      ; adunarea efectiva a celor doua numere stocate la adresele [0202h] si [0204h] 
    MOV [0204h],AX
    RET               
  

SCADERE:                                
    CALL SCADERE_fin  ; apelare metoda scadere     
    JMP REZULTAT      ; afisare rezultat  
SCADERE_fin:         
    PRINT 'SCADERE ' ; afisare nume operatie    
    SBB AX,[0202h]   ; scaderea efectiva a numerelor de la cele doua adrese   
    MOV [0204h],AX      
    RET                 
        
        
INMULTIRE:                  
    CALL INMULTIRE_fin  ; apelare metoda inmultire 
    JMP REZULTAT        ; afisare rezultat    
INMULTIRE_fin:    
    PRINT 'INMULTIRE '  ;afisare nume operatie
    MOV BX,[0202h]          
    MUL BX              ;inmultirea efectiva a numerelor de la cele doua adrese    
    MOV [0204h],AX          
    RET                     
                       
          
IMPARTIRE:                               
    CALL IMPARTIRE_fin ; apelare metoda impartire    
    JMP REZULTAT       ; afisare rezultat
IMPARTIRE_fin:      
    PRINT 'IMPARTIRE ' ; afisare nume operatie   
    MOV BX,[0202h]     ; impartirea efectiva a numerelor de la cele doua adrese
    DIV BX           
    MOV [0204h],AX 
    MOV [0206h],DX 
    RET            
                        
             
SI_LOGIC:                                       
    CALL SI_LOGIC_fin  ; apelare metoda SI_LOGIC_fin   
    JMP REZULTAT       ; afisare rezultat
SI_LOGIC_fin:     
    PRINT 'Rezultat SI ' ; afisare nume operatie
    AND AX,[0202h]       ; se realizeaza si logic intre operanzi
    MOV [0204h],AX      
    RET                 
                        
             
SAU_LOGIC:              
    CALL SAU_LOGIC_fin  ; apelare metoda SAU_LOGIC_fin
    JMP REZULTAT        ; afisare rezultat
SAU_LOGIC_fin:    
    PRINT 'SAU '        ; afisare nume operatie
    OR AX,[0202h]       ; se realizeaza sau logic intre operanzi
    MOV [0204h],AX      
    RET                 
                     
           
XOR_LOGIC:                 
    CALL XOR_LOGIC_fin   ; apelare metoda XOR_LOGIC_fin  
    JMP REZULTAT         ; afisare rezultat  

XOR_LOGIC_fin:     
    PRINT ' XOR '        ; afisare nume operatie
    XOR AX,[0202h]       ; se realizeaza xor logic intre operanzi
    MOV [0204h],AX  
    RET  
                    
             
REZULTAT: ; metoda de afisare a rezultatelor indiferent de tipul lor        
    PRINT '-> REZULTAT:  '  
    CALL PRINT_NUM                      
    CALL BEEP         ; se apeleaza metoda beep care initiaza un sunet ce anunta utilizator ca operatia a luat sfarsit
    GOTOXY 1,19                         
    PRINT 'Press any key to continue'  ; dupa finalizarea operatiei se asteapta apasarea unei taste 
    MOV AH,0h                           
    INT 16h                                      
    GOTOXY 1,19   ; se repozitioneaza cursorul                      
    PRINT '                         '     
    GOTOXY 1,20                        
    PRINT 'Doriti sa rulati programul din nou ?'  ; utilizatorul poate alege daca vrea sa ruleze programul in continuare sau sa-l opreasca  
    print '     '  
    PRINT '1=Da    2=Nu'       
    GOTOXY 1,22       ; repozitionare cursor         
    PRINT 'Optiune : '         

  
CHOOSE_FALSE_B:  ; daca utilizatorul alege o optiune gresita programul este reinitializat  
    CALL SCAN_NUM ; se citeste numarul     
    CMP CX,1h          
    JE AGAIN      ; se reinitializeaza programul(conditional)     
    CMP CX,2h          
    JE FINAL      ; se sare in etapa de final(conditional)      
    JMP FALSE_B          
  
    
BEEP:
    MOV AH, 02
    MOV DL, 07H ;valoarea ce stabileste tonul sunetului
    INT 21H ;producere sunet
    RET       
             
  
AGAIN:       
    CALL CLEAR_SCREEN  ; se goleste ecranul 
    JMP START          ; se reinitializeaza programul   
   
  
FALSE_A:         ; se afiseaza mesajul corespunzator pentru alegerea unei optiuni gresite          
    PRINT 'OPERATIUNE INVALIDA '     
    GOTOXY 2,15                      
    PRINT 'ALEGE OPTIUNE: '          
    JMP CHOOSE_FALSE_A                 
                                           
  
FALSE_B:         ; se afiseaza mesajul corespunzator pentru alegerea unei optiuni gresite       
    GOTOXY 1,23                  
    PRINT 'OPERATIUNE INVALIDA ' 
    GOTOXY 1,22  
    PRINT 'ALEGE OPTIUNE '       
    JMP CHOOSE_FALSE_B            

  
FINAL:      ; partea de incheiere a programului
    CALL CLEAR_SCREEN  ; ecranul se goleste            
    GOTOXY 3,21  
    PRINT 'IESIRE PROGRAM'   ; se afiseaza mesaje       
    GOTOXY 28,4                    
    PRINT 'STUDENT'                
    GOTOXY 28,5                    
    PRINT 'NUME --> GEORGESCU ANDI'
    GOTOXY 28,6                    
    PRINT 'GRUPA --> 334AA'        
    
    GOTOXY 28,7                               
    PRINT 'APASATI ORICE BUTON PENTRU A PARASI PROGRAMUL'  ; se asteapta apasarea unui buton pentru ca programul sa intre in halt
    MOV AH,0h                 
    INT 16h        
    PRINT ''  

HLT         ;incheiere program
  
DEFINE_SCAN_NUM     ; ne permite utilizarea instructiunii scan_num          
DEFINE_PRINT_NUM    ; ne permite utilizarea instructiunii print_num          
DEFINE_PRINT_NUM_UNS ; ne permite utilizarea intructiunii print_num          
DEFINE_CLEAR_SCREEN  ; ne permite utilizarea instructiunii clear_screen            

  
END           ; ORICE COD EXISTA DUPA COMANDA END ESTE IGNORAT DE CATRE PROGRAM