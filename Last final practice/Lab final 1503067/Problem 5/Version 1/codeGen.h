enum code_ops {START,HALT, LD_INT_VALUE, STORE, WRITE_INT, LD_VAR, ADD, LD_INT,JUMP_FALSE,LABEL, GOTO, JUMP_EQUAL, MULT, DIV,JUMP_LT,JUMP_GT,SUBS,JUMP_GTE,JUMP_LTE};

char *op_name[] = {"start", "halt", "ld_int_value", "store", "write_int", "ld_var", "add", "ld_int","jump_false","label", "goto", "jump_equal", "mult", "div","jump_lt","jump_gt","subs","jump_gte","jump_lte"};

struct instruction
{
    enum code_ops op;
    int arg;
};

struct instruction code[999];

int code_offset = 0;

void gen_code(enum code_ops op, int arg)
{
    code[code_offset].op = op;
    code[code_offset].arg = arg;
    
    code_offset++;
}

void print_code()
{
    int i = 0;

    for(i=0; i<code_offset; i++)
    {
        printf("%3d: %-15s  %4d\n", i, op_name[code[i].op], code[i].arg);

    }
}

void print_assembly()
{
    int i = 0;

    for(i=0; i<code_offset; i++)
    {
        printf("\n#%s\n", op_name[code[i].op]);

        switch(code[i].op)
        {
            case START:
                            //printf(".data\nmsg: .asciiz “\n”")
                            printf(".text\n");
                            printf(".globl main\n");
                            printf("main:\n");
                            printf("addiu $t7, $sp, 1000\n");
                            break;

            case HALT:
                            printf("li $v0, 10\n");
                            printf("syscall\n");
                            break;
            
            case LD_INT_VALUE:
                            printf("li $a0, %d\n", code[i].arg);
                            break;

            case STORE:
                            printf("sw $a0, %d($t7)\n", 16*code[i].arg);
                            break;

            case WRITE_INT:
                            printf("lw $a0, %d($t7)\n", 16*code[i].arg);
                            printf("li $v0, 1\n");
                            printf("move $t0, $a0\n");
                            printf("syscall\n");
                    
                            break;
            
            case LD_VAR    : 
                            printf("lw $a0, %d($t7)\n", 16*code[i].arg);
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case LD_INT    :
                            printf("li $a0, %d\n", code[i].arg);
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case ADD       :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("add $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;
            
            case MULT       :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("mult $a0, $t1\n");
                            printf("mflo $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case DIV       :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("div $t1, $a0\n");
                            printf("mflo $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;
            case SUBS       :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("sub $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;
            case JUMP_FALSE  :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n"); 
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n"); 
                            printf("addiu $sp, $sp, 16\n");
                            printf("ble $t1, $a0, LABEL%d\n",code[i].arg);
                            break;

            case JUMP_GT         :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n"); 
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n"); 
                            printf("addiu $sp, $sp, 16\n");
                            printf("ble $t1, $a0, LABEL%d\n",code[i].arg);
                            break;

             case JUMP_LT         :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n"); 
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n"); 
                            printf("addiu $sp, $sp, 16\n");
                            printf("bge $t1, $a0, LABEL%d\n",code[i].arg);
                            break;

            case JUMP_GTE         :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n"); 
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n"); 
                            printf("addiu $sp, $sp, 16\n");
                            printf("slt $t1,$t1,$a0\n");
                            printf("beq $t1, 1, LABEL%d\n",code[i].arg);
                            break;

             case JUMP_LTE        :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n"); 
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n"); 
                            printf("addiu $sp, $sp, 16\n");
                            printf("slt $t1,$a0,$t1\n");
                            printf("beq $t1, 1, LABEL%d\n",code[i].arg);
                            break;

                            
            
            case JUMP_EQUAL : 
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("beq $t1, $a0, LABEL%d\n",code[i].arg);
                            break;

            case LABEL     :
                            printf("LABEL%d:\n",code[i].arg);
                            break;

            case GOTO       :
                            printf("b LABEL%d\n", code[i].arg);
                            break;
            
            
                            


            default:
                            break;
        }

    }
}