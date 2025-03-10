   	        ##################################################################################
		#										 #
		#			ENCS4370: COMPUTER ARCHITECTURE         	         #
		#			     Course Project 1 :			         	 #
		#		MIPS Assembly Implementation of a System of Linear
                #                          Equations Solver Using Cramer’s Rule                  #
		#										 #
		#				                        			 #
		#			Student Name#1:Noura khdour			      
		#		                                		                 #			      
		#                                                                                #
		#										 #
		##################################################################################								              

   	 
   	  
   	    .data
	userInput:     .asciiz "Enter the input file name or path: "
	fileName:      .asciiz ""  
	fileName2:      .asciiz "output.txt"           		           		  
	fileWords:     .space 1024          		  
	fileWords2:    .space 1024
	openSuccess:   .asciiz "File opened successfully.\n"
	openFail:      .asciiz  "Error: Could not open file.\n"
	fileEmpty:     .asciiz "\n The file is empty.\n"
	coefficients_matrix: .space 36          	 
	coefficients_matrix2: .space 16
	copy_coefficients_matrix: .space 36
	copy_coefficients_matrix2: .space 16
	variables_martix: .space 3
	variables_martix2:.space 2
	result_matrix:  .word 0,0,0
	result_matrix2:.word 0, 0
	coefficients_det_msg: .asciiz "The determinant of cofficients matrix is : "
	det_msg:.asciiz "The result is : "
	sign:.asciiz "="
	slash:"/"
	error_msg : .asciiz "Error:Division by zero"
	coefficients_det:.word 0
	coefficients_det1:.word 0
	copy_matrix_det:.word 0
	choice: .word 4 				
	newline: .asciiz "\n"
	space: .asciiz "\t"
	buffer:        .space 1               
	msg_valid:     .asciiz "\n File is valid.\n"
	msg_invalid:   .asciiz "\n File is invalid.\n"
	stars : .asciiz "\t\t\t************************************************************** \n"
        Welcom:.asciiz "\t\t\t\tLinear Equations Solve by Cramers Rule using MIPS "
	Names: .asciiz "\t\t\t\t\t Noura khdour & Rwand Bawatneh"
	msg1:.asciiz "1: Enter v or V to check validation of input file "
	msg2:.asciiz "2: Enter f or F to print on output file"
	msg3:.asciiz "3: Enter s or S to print on screen "
	msg4:.asciiz "4: Enter e or E to exit"
	msg5:.asciiz "invalid choice,try agin"
	msg6:.asciiz "please enter a character : "
	msg7:.asciiz  "********** System 3x3 **********"
	msg8:.asciiz  "********** System 2x2 **********"
    	.text
    	.globl main
main:

#Dispaly message name and the project
    ##print new line
	li $v0, 11				# code to cal print  character 
	li $a0, 10 				# print new line exit (terminate execution)
        syscall
   	## 
    ##print new line
	li $v0, 11				# code to cal print  character 
	li $a0, 10 				# print new line exit (terminate execution)
        syscall
   	## 
	li $v0,4                  		# code call print string message 
   	la $a0, Welcom		 	        # message Name of project
   	syscall
   	
   ##print new line
	li $v0, 11				# code to cal print  character 
	li $a0, 10 				# print new line exit (terminate execution)
        syscall
   	## 
   	li $v0,4                 		# code call print string message 
   	la $a0, Names		  		# message print names
   	syscall
   	
   	##print new line
	li $v0, 11				# code to cal print  character 
	li $a0, 10 				# print new line exit (terminate execution)
        syscall
 
       li $v0,4                 		
       la $a0, stars		  		
   	syscall
#*********************************#
## reading the file data and entering it
 
read_file: 
    # ask the user to enter the filename
    li $v0, 4                       	 # Print string syscall code
    la $a0, userInput               	 # Load address of the prompt message
    syscall

    # Read the filename from user input
    li $v0, 8                       	 # Read string syscall code
    la $a0, fileName                	 # Address to store filename
    li $a1, 100                     	 # Max characters for filename
    syscall

#remove the new line charachter 
   	 la $a0,fileName 	    	 # pass filename to $a0 register
    	add $a0,$a0,100

# finding the new line character

remove_enter:
	lb $v0,0($a0) 			# get buffer character value
	bne $v0,$zero, end 		# if reached the end
	sub $a0,$a0,1 			# subtracting 1 from $a0
	j remove_enter
end: 					# define end of line 
	sb $zero,0($a0) 		# replace the new line character with null


    # Open the file (for reading)
  	 li $v0, 13                      	  # Open file syscall code
	 la $a0, fileName                	  # Load filename
         li $a1, 0                       	 # Read-only flag
         syscall
         bltz $v0, error_input_file      	# if $v0 is less than 0, there is an error found
         move $t0,$v0 	   	    	# save file descriptor in $t0
     

    # Print success message for debugging
  	  li $v0, 4
  	  la $a0, openSuccess
  	  syscall

#*********************************#
loop25:
	li $v0, 11			
	li $a0, 10 				
        syscall
 ##print new line
	li $v0, 11				# code to cal print  character 
	li $a0, 10 				# print new line exit (terminate execution)
        syscall
   	## 
	li $v0,4                  		# code call print string message 
   	la $a0, msg1		 	        # message Name of project
   	syscall

 ##print new line
	li $v0, 11				 
	li $a0, 10 				
        syscall
   	## 
	li $v0,4                  		 
   	la $a0, msg2		 	        
   	syscall

 ##print new line
	li $v0, 11				 
	li $a0, 10 				
        syscall
   	## 
	li $v0,4                  	 
   	la $a0, msg3		 	        
   	syscall


 ##print new line
	li $v0, 11				 
	li $a0, 10 				
        syscall
   	## 
	li $v0,4                  		 
   	la $a0, msg4		 	        
   	syscall
 ##print new line
	li $v0, 11				
	li $a0, 10 				
        syscall
   	## 
	li $v0,4                  		 
   	la $a0, msg6		 	        
   	syscall


#Read from user 
   	li $v0,12 				
   	syscall
   	sw $v0, choice

      #  lw $at ,choice
        beq $v0, 'e', End_Programe   
        beq $v0, 'E', End_Programe
        #beq $v0,'f',output_file
        
        beq $v0, 'v', validation   
        beq $v0, 'V', validation 
              
        beq $v0, 's', here   
        beq $v0, 'S', here 
        
        bne $v0 ,'s',warning_msg


        
warning_msg:
##print new line
	li $v0, 11			
	li $a0, 10 				
        syscall
	li $v0,4                  		 
   	la $a0, msg5		 	        
   	syscall 
        j loop25
        
validation:
# Read the first character and validate it is a digit
    li $v0, 14                       # Syscall for read from file
    move $a0, $t0                    # File descriptor
    la $a1, buffer                   # Address of buffer to store the character
    li $a2, 1                        # Number of bytes to read (1 byte for 1 character)
    syscall

   j process_character
    

newline_character:
    # Check for newline character
    li $v0, 14                       # Syscall for read from file
    move $a0, $t0                    # File descriptor
    la $a1, buffer                   # Address of buffer to store the character
    li $a2, 1                        # Number of bytes to read (1 byte for 1 character)
    syscall
    beqz $v0, end_of_file            # If $v0 == 0, end of file reached
    lb $t3, buffer                    # Load the character read
    beq  $t3,10, end_of_line            # If $v0 == 0, end of file reached
    beq $t3, 13  , end_of_line         # If the character is '\n', jump to end_of_line

    # Continue processing character
    j process_character
end_of_line:
    # Reset step to start of a new line
     li $t9,0
    li $t1, 0                      # Reset step counter (if using)
    j newline_character               # Continue reading next character

##############   VALIDATION  ##########################
    li $t1, 0                      # step counter
    li $t9,0
process_character:

    lb $t3, buffer                   # Load the character read
    bgt $t9,3,error
    li $t4, 32                       # ASCII value for space (' ')
    beq $t3, $t4, newline_character     # If space, continue reading

    # Step 0: Expecting a digit
    beq $t1, 0, check_digit
    # Step 1: Expecting an alphabet character
    beq $t1, 1, check_alpha
    # Step 2: Expecting either '+' or '-' or '='
    beq $t1, 2, check_sign
    # Step 3 : Expecting a digit
    beq $t1, 3, check_digit
   # j newline_character
    # Step 4 Expecting an alphabet character
    beq $t1, 4, check_alpha
    # Step 5: Expecting '+' or '-' or '=' symbol
    beq $t1, 5, check_sign
    # Step 6: Expecting a digit
    beq $t1, 6, check_digit
   # j newline_character
    # Step 7 Expecting an alphabet character
    beq $t1,7, check_alpha
    beq $t1, 8, check_sign
    # Step 9: Expecting a digit
    beq $t1, 9, check_digit
    j newline_character
    
check_digit:
    # Validation logic based on the sequence step
    li $t4, 48                       # ASCII value of '0'
    li $t5, 57                       # ASCII value of '9'
    li $t6, 45                       # ASCII value of '-' (negative sign)
    beq $t3,$t6,newline_character
   # Check if character is a digit
    blt $t3, $t4, error              # If less than '0', invalid
    bgt $t3, $t5, error              # If greater than '9', invalid
    addi $t1, $t1, 1                 # Move to next step (expecting alphabet)
    j newline_character
check_alpha:
    # Check if character is an alphabet (A-Z or a-z)
    li $t4, 65                       # ASCII value of 'A'
    li $t5, 90                       # ASCII value of 'Z'
    li $t6, 97                       # ASCII value of 'a'
    li $t7, 122                      # ASCII value of 'z'

    # Check if character is an uppercase alphabet
    blt $t3, $t4, check_lower_case   # If less than 'A', check lowercase
    bgt $t3, $t5, check_lower_case   # If greater than 'Z', check lowercase
    add $t9,$t9,1
    addi $t1, $t1, 1                 # Move to next step (expecting + or -)
    j newline_character
check_lower_case:
    # Check if character is a lowercase alphabet
    blt $t3, $t6, error              # If less than 'a', invalid
    bgt $t3, $t7, error              # If greater than 'z', invalid
    add $t9,$t9,1
    addi $t1, $t1, 1                 # Move to next step (expecting + or -)
    j newline_character
check_sign:
    # Check for '+' or '-'
    li $t4, 43                       # ASCII value of '+'
    li $t5, 45                       # ASCII value of '-'
    beq $t3, $t4, sign_found         # If '+' found
    beq $t3, $t5, sign_found         # If '-' found
   # Check for '=' symbol
    li $t4, 61                       # ASCII value of '='
    beq $t3, $t4, equals_found     # If '=' found
    j error                          # Invalid character for sign
sign_found:
    addi $t1, $t1, 1                 # Move to next step (expecting alphabet)
    j newline_character
equals_found:
    addi $t1, $t1, 1                 # Move to next step (expecting alphabet)
    j newline_character
end_of_file:
    # If end of file is reached and file is valid, print valid message
    li $v0, 4
    la $a0, msg_valid
    syscall
    j close_file                     # Close file and exit

close_file:
    # Close the file
    li $v0, 16                       # Close file syscall code
    move $a0, $t0                    # File descriptor to close
    syscall
    j loop25                           # Jump to exit


error:
    # Code to handle the error (e.g., print an error message)
    li $v0, 4                      # Print string syscall code
    la $a0, msg_invalid            # Load address of invalid message
    syscall
    j close_file 
        
 ##########                
here:       
 
    # Open the file (for reading)
  	 li $v0, 13                      	  # Open file syscall code
	 la $a0, fileName                	  # Load filename
         li $a1, 0                       	 # Read-only flag
         syscall
         bltz $v0, error_input_file      	# if $v0 is less than 0, there is an error found
         move $t0,$v0 	   	    	# save file descriptor in $t0
         
    # Read from the file
    	  li $v0, 14       			# system call for read to file
	  la $a1, fileWords    			# address of buffer from which to write
  	  li $a2, 1024     			# hardcoded buffer length
  	  move $a0, $t0    			# put the file descriptor in $a0		
  	  syscall 

    # Check if the file was empty
   	 beqz $v0, file_empty             # If nothing was read, go to file_empty

    # Print the content of the file
   	# li $v0, 4                        # Print string syscall code
   	# la $a0, fileWords                # Address of buffer to print
   	# syscall
    
    #print new line
   	 li $v0, 11        # Syscall code for printing a character
   	 li $a0, 10        # ASCII code for newline (LF, line feed)
   	 syscall


                   
                        
########################################### store the coefficient in Matrix of 3x3 system ###################################
three_by_three_system:
# Initialize array index to store coefficients
   	 li $t1, 0                      # Row index for matrix
   	 li $t2, 0                      # Column index for matrix

  	 #split and store into array
  	 # Parse line from filewords buffer

      	 la $s0,fileWords  			# laod address filewords
      	 addi $t0,$0,0 		                # Temp register 

loop:
	lb $s1,0($s0)				#load byte to read byte by byte
	addi $s0,$s0,1				# Move to next character in buffer
	beq $s1,$zero ,store_coefficient        # If end of line, go to store_coefficient
	# Check for equal sign
        beq $s1, '=', skip_rest_of_line
         
         #check for negative sign
        beq $s1, '-', negative_sign
          
        # Check if character is a digit (ASCII '0' to '9')
	blt $s1,48,skip1	 			#compare with asccii 0
	bgt $s1,57,skip1				#compare with asccii 9

        # Calculate array index and store the coefficient
        #check for multi digit
        li $t6, 0         			 # Initialize accumulator
        loop_digit_positive:
        mul $t6, $t6, 10 			 # Shift accumulator left by one digit
	subi $s1,$s1,48 			# to return from asccii to number
        add $t6, $t6, $s1 			 # Add the digit to the accumulator
        lb $s1, 0($s0)    			  #load the next chaecter
        addi $s0, $s0, 1
        blt $s1, 48, exit_loop1
        bgt $s1, 57,exit_loop1
        j loop_digit_positive
        
exit_loop1:
  
        sll $t8, $t1, 2                         # Calculate row offset (t1 * 4)
        add $t9, $t8, $t2                       # Calculate cell position
	sb $t6,coefficients_matrix($t0)		#store the value $s1
        addi $t2, $t2, 1             		 # Move to next column
	addi $t0,$t0,1				#increase 
	j loop
	
negative_sign:
# Load the next character (should be a digit)
   	 lb $s1, 0($s0)
   	 addi $s0, $s0, 1
     # Parse the digit as before
   	 li $t6, 0  # Initialize accumulator
 loop_digits_negative:
        mul $t6, $t6, 10  		# Shift accumulator left by one digit
        subi $s1, $s1, 48 		 # Convert ASCII digit to numeric value
        add $t6, $t6, $s1 		 # Add the digit to the accumulator
        lb $s1, 0($s0)  		# Load the next character
        addi $s0, $s0, 1
        blt $s1, 48, exit_loop2
        bgt $s1, 57, exit_loop2
        j loop_digits_negative

exit_loop2:
    # Negate the parsed value
    sub $t6, $zero, $t6
    # Store the negative coefficient
    sll $t8, $t1, 2 			 # Calculate row offset (t1 * 4)
    add $t9, $t8, $t2  			# Calculate cell position
    sb $t6, coefficients_matrix($t0)    # Store the negative coefficient
    addi $t2, $t2, 1  			# Move to next column
    addi $t0, $t0, 1  			# Increase array index
    j loop	
	
	
	
skip_rest_of_line:
    # Skip the rest of the line until the newline character
 loop_skip:
        lb $s1, 0($s0)
        addi $s0, $s0, 1
        bne $s1, '\n', loop_skip
        # Move to the next row
       addi $t1, $t1, 1 		 # Increment row index
        li $t2, 0  			# Reset column index for the next equation
        b loop
    
skip1:
	j loop
	
	
store_coefficient:	
    lw $s1, fileName
    add $t1, $t1, 1               	 # Move to the next row
    li $t2, 0                     	 # Reset column index for next equation


############################################### store the variables in martix for 3x3 system ##################################

    	li $t1, 0                     		 # row array index for matrix
    
   #split and store into array
       
       la $t2, variables_martix 	 	# Load the address of the variables_matrix
       la $s0,fileWords  			# laod address filewords


loop1:
	lb $s1,0($s0)			 	#load byte to read byte by byte
	addi $s0,$s0,1			       # Move to next character in buffer
	beq $s1,'=' ,store_variables         # If end of line, go to store_coefficient
	
	
    # Check if the character is a letter (A-Z or a-z)
	blt $s1,65,skip2	              #compare with asccii A (if less than A skip)
	bgt $s1,90,lowercase_letter	      #compare with asccii Z (if grater than Z check lowe case )
	
	
	# Store the uppercase letter in the array
        sb $s1, 0($t2)
        addi $t2, $t2, 1  # Increment the array pointer
        j loop1
        
lowercase_letter:
      # Store the uppercase letter in the array
      	 blt $s1, 97, skip2 			 # If less than 'a', skip
     	 bgt $s1, 122, skip2 			 # If greater than 'z', skip
    # Store the lowercase letter in the array
   	 sb $s1, 0($t2)
   	 addi $t2, $t2, 1 			 # Increment the array pointer
   	 j loop1
    
skip2:
	j loop1

	
store_variables:
  	 la $t2, variables_martix
   	 li $t1, 0                  # Reset row index for printing

 
########################################### store the result matrix for 3x3 system ##########################################

    	li $t1, 0                     		 # Row index for matrix
   
  	 #split and store into array
  	 # Parse line from filewords buffer
      
       la $s0,fileWords  			# laod address filewords
       la $t2, result_matrix
      

loop3:
	lb $s1,0($s0)				#load byte to read byte by byte
	addi $s0,$s0,1				# Move to next character in buffer
	beq $s1,$zero ,store_result       	 # If end of line, go to store_coefficient
	# Check for equal sign
         beq $s1, '=', check_result
         j loop3
 
 check_result:  
        li $t6, 0             		  # Initialize accumulator to zero
        li $t4, 1             	  # Default sign multiplier to 1 (positive)
        lb $s1, 0($s0)         		 # Load next character to check for '-'
        beq $s1, '-', negative_sign2   # If '-', go to handle negative sign
        j loop_digit_positive3
      
loop_digit_positive3:
          # Check if character is a digit (ASCII '0' to '9')
        lb $s1, 0($s0)     				 #load the next chaecter
        addi $s0, $s0, 1
   	blt $s1,48,skip3	 			#compare with asccii 0
	bgt $s1,57,skip3				#compare with asccii 9
        mul $t6, $t6, 10 				 # Shift accumulator left by one digit
	subi $s1,$s1,48 				# to return from asccii to number
        add $t6, $t6, $s1  				# Add the digit to the accumulator
        j loop_digit_positive3
        
  
skip3:
 	 mul $t6, $t6, $t4       # Apply sign to result
  	  sw $t6, 0($t2)          # Store the result in result_matrix
  	  addi $t2, $t2, 4        # Increment the matrix pointer (4 bytes for word)
	j loop3	
	
	
	
negative_sign2:
 	li $t4, -1              # Set sign multiplier to -1 for negative value
  	lb $s1, 0($s0)          # Load next character after '-'
   	addi $s0, $s0, 1
     	j loop_digit_positive3
	
	

store_result:	
 	la $t2,result_matrix 
   	 li $t1, 0                  # Reset row index for printing

   
######################### calculat the determinant of coefficients matrix for 3x3 system###################################
   la $t0,coefficients_matrix
# Load the matrix elements into registers
    # load the first row
    lb $at, 0($t0) 	 # a11
    lb $t1, 1($t0) 	 # a12
    lb $t2, 2($t0) 	 # a13
# load the second row
    lb $t3, 3($t0) 	# a21
    lb $t4, 4($t0) 	# a22
    lb $t5, 5($t0) 	# a23
 #load the third row
    lb $t6, 6($t0) 	# a31
    lb $t7, 7($t0) 	# a32
    lb $t8, 8($t0) 	# a33

# Calculate the sub-determinants
    mul $t9, $t4, $t8  	# a22 * a33
    mul $s0, $t5, $t7	 # a23 * a32
    sub $s1, $t9, $s0  	# a22*a33 - a23*a32

    mul $s2, $t3, $t8  # a21 * a33
    mul $s3, $t5, $t6  # a23 * a31
    sub $s4, $s2, $s3  # a21*a33 - a23*a31

    mul $s5, $t3, $t7  # a21 * a32
    mul $s6, $t4, $t6  # a22 * a31
    sub $s7, $s5, $s6  # a21*a32 - a22*a31
    
# Calculate the determinant
    mul $a0, $at, $s1  	# a11 * (a22*a33 - a23*a32)
    mul $a1, $t1, $s4  	# a12 * (a21*a33 - a23*a31)
    mul $a2, $t2, $s7 	 # a13 * (a21*a32 - a22*a31)
    add $a3, $a0, $a2 	 # a11*(a22*a33 - a23*a32) + a13*(a21*a32 - a22*a31)
    sub $k1, $a3, $a1 	 # a11*(a22*a33 - a23*a32) - a12*(a21*a33 - a23*a31) + a13*(a21*a32 - a22*a31)
    
	
# Print the message
	la $a0,msg7  # Load the address of the message
	li $v0, 4  # System call code for printing a string
	syscall   
# Print a newline character
         li $a0, 10
   	 li $v0, 11
   	 syscall        
# Print the message
	la $a0, coefficients_det_msg  # Load the address of the message
	li $v0, 4                      # System call code for printing a string
	syscall

# Print the determinant
	sw $k1,coefficients_det
	li $v0, 1                  # System call code for printing an integer
	lw $a0, coefficients_det  # Load the determinant from memory
	syscall
 # Print a newline character
         li $a0, 10
   	 li $v0, 11
   	 syscall
   	 
 	   	 
################################################ Exchange the coulmns for 3x3 system #######################################
# Create a copy of the coefficient matrix
	la $t0, coefficients_matrix
	la $t1, copy_coefficients_matrix
	li $t6, 0                    # Initialize a loop counter
copy_loop1:
	lb $t3, 0($t0)               # Load  from original_matrix
	sb $t3, 0($t1)               # Store word in copy_matrix
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t6, $t6, 1 #increse the counter
	bne $t6, 9, copy_loop1
	beq $t6, 9,replace_column1

replace_column1:
#replace the first column in a matrix with a constant vector
	la $t1,copy_coefficients_matrix
	la $t2,result_matrix
	la $v1,variables_martix
# Load the constant vector elements into registers
	lw $t3, 0($t2) 		 # First element of the constant vector
	lw $t4, 4($t2) 		 # Second element
	lw $t5, 8($t2)  	# Third element
	sb $t3,0($t1)
	sb $t4,3($t1)
	sb $t5 ,6($t1) 

	jal calculate_determinant
	beq $k1, $zero, division_by_zero # Check if the denominator is zero
# Print the message
	li $v0, 4  
	la $a0, det_msg  
	syscall
# Print a newline character
   	 li $a0, 10
    	li $v0, 11
    	syscall
#print the varaible
  	lb $a0, 0($v1)          # Load character to $a0
  	  li $v0, 11              # System call for printing a character
  	  syscall 
#print the sign eaual    
	li $v0, 4  
	la $a0, sign 
	syscall
#print the result
 	move $a0, $k0     
  	li $v0, 1               
   	 syscall 
#print sdivision sign          
  	 li $v0, 4  
  	la $a0, slash 
  	 syscall 
#print result   
 	move $a0, $k1     
   	 li $v0, 1               
   	 syscall 
# Print a newline character
   	 li $a0, 10
   	 li $v0, 11
   	 syscall


### reset the copy matrix 
	la $t0, coefficients_matrix
	la $t1, copy_coefficients_matrix
	li $t6, 0                    # Initialize a loop counter
copy_loop2:
	lb $t3, 0($t0)               # Load  from original_matrix
	sb $t3, 0($t1)               # Store word in copy_matrix
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t6, $t6, 1 	#increse the counter
	bne $t6, 9, copy_loop2
	beq $t6, 9,replace_column2
   
replace_column2: 
	la $t1,copy_coefficients_matrix
	la $t2,result_matrix
	la $v1,variables_martix
#replace the second coulmn 
	lw $t3, 0($t2)  	# First element of the constant vector
	lw $t4, 4($t2)  		# Second element
	lw $t5, 8($t2)  		# Third element
	sb $t3,1($t1)
	sb $t4,4($t1)
	sb $t5 ,7($t1) 
	jal calculate_determinant
	beq $k1, $zero, division_by_zero 	 # Check if the denominator is zero
#print the varaible
  	lb $a0, 1($v1)        			  # Load character to $a0
   	li $v0, 11             			 # System call for printing a character
   	syscall 
#print the sign eaual    
	li $v0, 4  
	la $a0, sign 
	syscall
#print the result
	move $a0, $k0     
       li $v0, 1               
       syscall 
#print division sign          
  	li $v0, 4  
  	la $a0, slash 
        syscall 
#print result   
	move $a0, $k1     
 	li $v0, 1               
       syscall 
# Print a newline character
       li $a0, 10
       li $v0, 11
       syscall


### reset the copy matrix 
	la $t0, coefficients_matrix
	la $t1, copy_coefficients_matrix
	li $t6, 0                    # Initialize a loop counter
copy_loop3:
	lb $t3, 0($t0)               # Load  from original_matrix
	sb $t3, 0($t1)               # Store word in copy_matrix
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t6, $t6, 1 		#increse the counter
	bne $t6, 9, copy_loop3
	beq $t6, 9,replace_coulmn3

replace_coulmn3: 
	la $t1,copy_coefficients_matrix
	la $t2,result_matrix
	la $v1,variables_martix
#replace the third coulmn
	lw $t3, 0($t2)  	# First element of the constant vector
	lw $t4, 4($t2)  	# Second element
	lw $t5, 8($t2)  	# Third element
	sb $t3,2($t1)
	sb $t4,5($t1)
	sb $t5 ,8($t1) 
	jal calculate_determinant
	beq $k1, $zero, division_by_zero 	# Check if the denominator is zero

#print the varaible
  	lb $a0, 2($v1)          # Load character to $a0
  	li $v0, 11              # System call for printing a character
  	 syscall 
#print the sign eaual    
	li $v0, 4  
	la $a0, sign 
	syscall
#print the result
	 move $a0, $k0     
  	 li $v0, 1               
  	 syscall 
#print sdivision sign          
 	 li $v0, 4  
 	 la $a0, slash 
 	  syscall 
#print result   
	 move $a0, $k1     
   	 li $v0, 1               
   	 syscall 
# Print a newline character
   	 li $a0, 10
   	 li $v0, 11
   	 syscall

	j print_line
### calculate the deterninant of replace matrix
calculate_determinant:
    la $t0,copy_coefficients_matrix
# Load the matrix elements into registers
    # load the first row
    lb $at, 0($t0)  # a11
    lb $t1, 1($t0)  # a12
    lb $t2, 2($t0)  # a13
    # load the second row
    lb $t3, 3($t0) # a21
    lb $t4, 4($t0) # a22
    lb $t5, 5($t0) # a23
    #load the third row
    lb $t6, 6($t0) # a31
    lb $t7, 7($t0) # a32
    lb $t8, 8($t0) # a33

# Calculate the sub-determinants
    mul $t9, $t4, $t8  # a22 * a33
    mul $s0, $t5, $t7 # a23 * a32
    sub $s1, $t9, $s0  # a22*a33 - a23*a32

    mul $s2, $t3, $t8  # a21 * a33
    mul $s3, $t5, $t6  # a23 * a31
    sub $s4, $s2, $s3  # a21*a33 - a23*a31

    mul $s5, $t3, $t7  # a21 * a32
    mul $s6, $t4, $t6  # a22 * a31
    sub $s7, $s5, $s6  # a21*a32 - a22*a31
    
     # Calculate the determinant
    mul $a0, $at, $s1  # a11 * (a22*a33 - a23*a32)
    mul $a1, $t1, $s4  # a12 * (a21*a33 - a23*a31)
    mul $a2, $t2, $s7  # a13 * (a21*a32 - a22*a31)
    add $a3, $a0, $a2  # a11*(a22*a33 - a23*a32) + a13*(a21*a32 - a22*a31)
    sub $k0, $a3, $a1  # a11*(a22*a33 - a23*a32) - a12*(a21*a33 - a23*a31) + a13*(a21*a32 - a22*a31)
   #the result now in $k1
 
	jr $ra  # Return to the instruction after the jal
division_by_zero:
	li $v0, 4  
	la $a0, error_msg  
	syscall

print_line:
# Print a newline character
    li $a0, 10
    li $v0, 11
    syscall
    

#################### 2x2 system #################
	li $t0, 0           # Equation counter
	li $t1, 0           # Buffer index for fileWords
	li $t3, 0           # Buffer index for fileWords2

loop15:
  # Load the current character from fileWords
  lb $t2, fileWords($t1)

  # Check for newline character
  beq $t2, '\n', check_system_size

  # Increment buffer index and continue loop
  addi $t1, $t1, 1
  j loop15

check_system_size:
  addi $t0, $t0, 1         # Increment equation counter

  # Check if it's a 3x3 system (or any other condition)
  beq $t0, 3, reset_for_next_system

  # If it's not the 3x3 system, move to the next character
  addi $t1, $t1, 1
  j loop15

reset_for_next_system:
  # Reset equation counter for next system
  li $t0, 0

  # Skip the empty line (newline character)
reset_skip_empty_line:
  lb $t2, fileWords($t1)    # Load next character
  addi $t1, $t1, 1          # Move to next character
  bne $t2, '\n', reset_skip_empty_line  # Continue until newline


  # Start copying the second system to fileWords2
  j call_two_by_two

call_two_by_two:
  lb $t2, fileWords($t1)    # Load next character from fileWords
  sb $t2, fileWords2($t3)   # Store the character in fileWords2
  addi $t3, $t3, 1         # Increment fileWords2 index



  # Check if the character is a newline (end of second system)
  beq $t2, '\n', reset_for_next_system   # If newline, finish current system
  beqz $t2, two_by_two_system               # End of program check

  # Increment buffer index and continue copying
  addi $t1, $t1, 1
  j call_two_by_two
  
  

two_by_two_system:
######################################### store cofficents for 2x2 system #########################################
# Initialize array index to store coefficients
    li $t1, 0                      # Row index for matrix
    li $t2, 0                      # Column index for matrix

   #split and store into array
   # Parse line from filewords buffer

       la $s0,fileWords2	# laod address filewords
       addi $t0,$0,0 		                # Temp register 

loop16:
	lb $s1,0($s0)				#load byte to read byte by byte
	addi $s0,$s0,1				# Move to next character in buffer
	beq $s1,$zero ,store_coefficient16        # If end of line, go to store_coefficient
	# Check for equal sign
        beq $s1, '=', skip_rest_of_line16
         
         #check for negative sign
        beq $s1, '-', negative_sign16
          
        # Check if character is a digit (ASCII '0' to '9')
	blt $s1,48,skip16	 			#compare with asccii 0
	bgt $s1,57,skip16				#compare with asccii 9

        # Calculate array index and store the coefficient
        #check for multi digit
        li $t6, 0          # Initialize accumulator
        loop_digit_positive16:
        mul $t6, $t6, 10  # Shift accumulator left by one digit
	subi $s1,$s1,48 			# to return from asccii to number
        add $t6, $t6, $s1  # Add the digit to the accumulator
        lb $s1, 0($s0)      #load the next chaecter
        addi $s0, $s0, 1
        blt $s1, 48, exit_loop16
        bgt $s1, 57,exit_loop16
        j loop_digit_positive16
        
exit_loop16:
  
        sll $t8, $t1, 2                         # Calculate row offset (t1 * 4)
        add $t9, $t8, $t2                       # Calculate cell position
	sb $t6,coefficients_matrix2($t0)			#store the value $s1
        addi $t2, $t2, 1              # Move to next column
	addi $t0,$t0,1				#increase 
	j loop16
	
negative_sign16:
# Load the next character (should be a digit)
   	 lb $s1, 0($s0)
   	 addi $s0, $s0, 1
     # Parse the digit as before
   	 li $t6, 0  # Initialize accumulator
loop_digits_negative16:
        mul $t6, $t6, 10  # Shift accumulator left by one digit
        subi $s1, $s1, 48  # Convert ASCII digit to numeric value
        add $t6, $t6, $s1  # Add the digit to the accumulator
        lb $s1, 0($s0)  # Load the next character
        addi $s0, $s0, 1
        blt $s1, 48, exit_loop17
        bgt $s1, 57, exit_loop17
        j loop_digits_negative16

exit_loop17:
    # Negate the parsed value
    sub $t6, $zero, $t6
    # Store the negative coefficient
    sll $t8, $t1, 2  # Calculate row offset (t1 * 4)
    add $t9, $t8, $t2  # Calculate cell position
    sb $t6, coefficients_matrix2($t0)  # Store the negative coefficient
    addi $t2, $t2, 1  # Move to next column
    addi $t0, $t0, 1  # Increase array index
    j loop16	
	
	
	
skip_rest_of_line16:
    # Skip the rest of the line until the newline character
 loop_skip16:
        lb $s1, 0($s0)
        addi $s0, $s0, 1
        bne $s1, '\n', loop_skip16
        # Move to the next row
       addi $t1, $t1, 1  # Increment row index
        li $t2, 0  # Reset column index for the next equation
        b loop16
    
skip16:
	j loop16
	
	
store_coefficient16:	
 	 lw $s1, fileName
   	 add $t1, $t1, 1                # Move to the next row
   	 li $t2, 0                      # Reset column index for next 
    
#################################### store the variables in martix 2x2 #########################################
# Initialize array index to store coefficients
   	 li $t1, 0                      # row array index for matrix
    
   #split and store into array
       
       la $t2, variables_martix2  # Load the address of the variables_matrix
       la $s0,fileWords2		# laod address filewords
      # addi $t0,$0,0 		                # Temp register 

loop18:
	lb $s1,0($s0)				#load byte to read byte by byte
	addi $s0,$s0,1			       # Move to next character in buffer
	beq $s1,'=' ,store_variables18         # If end of line, go to store_coefficient
	
    # Check if the character is a letter (A-Z or a-z)
	blt $s1,65,skip18	              #compare with asccii A (if less than A skip)
	bgt $s1,90,lowercase_letter18	      #compare with asccii Z (if grater than Z check lowe case )
	 # Store the uppercase letter in the array
        sb $s1, 0($t2)
        addi $t2, $t2, 1  # Increment the array pointer
        j loop18
        
lowercase_letter18:
      # Store the uppercase letter in the array
     	  blt $s1, 97, skip18  # If less than 'a', skip
    	  bgt $s1, 122, skip18  # If greater than 'z', skip
    # Store the lowercase letter in the array
   	 sb $s1, 0($t2)
   	 addi $t2, $t2, 1  # Increment the array pointer
    	j loop18
    
skip18:
j loop18

	
store_variables18:
   la $t2, variables_martix2
    li $t1, 0                  # Reset row index for printing

################################### store the result matrix for 2x2 system ##################################################
   # Initialize array index to store coefficients
   	 li $t1, 0                      # Row index for matrix
   
   #split and store into array
   # Parse line from filewords buffer
      
       la $s0,fileWords2 			# laod address filewords
       la $t2,result_matrix2
      

loop19:
	lb $s1,0($s0)				#load byte to read byte by byte
	addi $s0,$s0,1				# Move to next character in buffer
	beq $s1,$zero ,store_result19        # If end of line, go to store_coefficient
	# Check for equal sign
         beq $s1, '=',check_result19
         j loop19
 
 check_result19:  
        li $t6, 0               # Initialize accumulator to zero
        li $t4, 1               # Default sign multiplier to 1 (positive)
        lb $s1, 0($s0)          # Load next character to check for '-'
        beq $s1, '-', negative_sign19   # If '-', go to handle negative sign
        j loop_digit_positive19
      
loop_digit_positive19:
          # Check if character is a digit (ASCII '0' to '9')
        lb $s1, 0($s0)      #load the next chaecter
        addi $s0, $s0, 1
   	blt $s1,48,skip19	 			#compare with asccii 0
	bgt $s1,57,skip19				#compare with asccii 9
        mul $t6, $t6, 10  # Shift accumulator left by one digit
	subi $s1,$s1,48 			# to return from asccii to number
        add $t6, $t6, $s1  # Add the digit to the accumulator
        j loop_digit_positive19  
skip19:
	 mul $t6, $t6, $t4       # Apply sign to result
   	 sw $t6, 0($t2)          # Store the result in result_matrix
   	 addi $t2, $t2, 4        # Increment the matrix pointer (4 bytes for word)
	j loop19	

negative_sign19:
	  li $t4, -1              # Set sign multiplier to -1 for negative value
  	  lb $s1, 0($s0)          # Load next character after '-'
   	 addi $s0, $s0, 1
      	 j loop_digit_positive19
	
	

store_result19:	
 	la $t2,result_matrix2 
   	 li $t1, 0                  # Reset row index for printing
    	

####################################### calculate the Determinant for 2x2 system ######################################    
    la $t0,coefficients_matrix2
# Load the matrix elements into registers
    # load the first row
    lb $t1, 0($t0)  # a11  a
    lb $t2, 1($t0)  # a12  b
    # load the second row
    lb $t3, 2($t0) # a21  c
    lb $t4, 3($t0) # a22  d
   
# Calculate the sub-determinants
    mul $t5, $t1, $t4  # a11 * a22
    mul $t6, $t2, $t3 # a12*a21
    sub $t7, $t5, $t6  # a22*a33 - a23*a32 ---> result

   # Print the message
	la $a0,msg8  # Load the address of the message
	li $v0, 4  # System call code for printing a string
	syscall   
# Print a newline character
         li $a0, 10
   	 li $v0, 11
   	 syscall 
# Print the message
	la $a0, coefficients_det_msg  # Load the address of the message
	li $v0, 4  # System call code for printing a string
	syscall

# Print the determinant
	sw $t7,coefficients_det1
	li $v0, 1  # System call code for printing an integer
	lw $a0, coefficients_det1  # Load the determinant from memory
	syscall
 # Print a newline character
    li $a0, 10
    li $v0, 11
    syscall

################################################# Exchange the coulmns  for 2x2 system ####################################
# Create a copy of the coefficient matrix
	la $t0, coefficients_matrix2
	la $t1, copy_coefficients_matrix2
	li $t6, 0                    # Initialize a loop counter
copy_loop20:
	lb $t3, 0($t0)               # Load  from original_matrix
	sb $t3, 0($t1)               # Store word in copy_matrix
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t6, $t6, 1 #increse the counter
	bne $t6, 4, copy_loop20
	beq $t6, 4,replace_column20

replace_column20:
#replace the first column in a matrix with a constant vector
	la $t1,copy_coefficients_matrix2
	la $t2,result_matrix2
	la $v1,variables_martix2
# Load the constant vector elements into registers
	lw $t3, 0($t2)  # First element of the constant vector
	lw $t4, 4($t2)  # Second element
	sb $t3,0($t1)
	sb $t4,2($t1)

	jal calculate_determinant20
	beq $t7, $zero, division_by_zero2 # Check if the denominator is zero
# Print the message
	li $v0, 4  
	la $a0, det_msg  
	syscall
# Print a newline character
  	li $a0, 10
        li $v0, 11
        syscall
#print the varaible
	lb $a0, 0($v1)          # Load character to $a0
	li $v0, 11              # System call for printing a character
 	syscall 
#print the sign eaual    
	li $v0, 4  
	la $a0, sign 
	syscall
#print the result
 	move $a0, $t8    
   	 li $v0, 1               
   	 syscall 
#print sdivision sign          
  	 li $v0, 4  
  	la $a0, slash 
  	 syscall 
#print result   
	 move $a0, $t7    
  	  li $v0, 1               
  	  syscall 
# Print a newline character
  	  li $a0, 10
   	 li $v0, 11
   	 syscall

##########################
### reset the copy matrix 
	la $t0, coefficients_matrix2
	la $t1, copy_coefficients_matrix2
	li $t6, 0                    # Initialize a loop counter
copy_loop21:
	lb $t3, 0($t0)               # Load  from original_matrix
	sb $t3, 0($t1)               # Store word in copy_matrix
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	addi $t6, $t6, 1 #increse the counter
	bne $t6, 4, copy_loop21
	beq $t6, 4,replace_column21
   
replace_column21: 
	la $t1,copy_coefficients_matrix2
	la $t2,result_matrix2
	la $v1,variables_martix2
#replace the second coulmn 
	lw $t3, 0($t2)  # First element of the constant vector
	lw $t4, 4($t2)  # Second element

	sb $t3,1($t1)
	sb $t4,3($t1)

	jal calculate_determinant20
	beq $t7, $zero, division_by_zero2 # Check if the denominator is zero
#print the varaible
  	lb $a0, 1($v1)          # Load character to $a0
    	li $v0, 11              # System call for printing a character
    	syscall 
#print the sign eaual    
	li $v0, 4  
	la $a0, sign 
	syscall
#print the result
 	move $a0, $t8     
    	li $v0, 1               
    	syscall 
#print division sign          
  	 li $v0, 4  
  	la $a0, slash 
   	syscall 
#print result   
	 move $a0, $t7     
   	 li $v0, 1               
   	 syscall 
# Print a newline character
   	 li $a0, 10
   	 li $v0, 11
   	 syscall
j print_line20
###############     
### calculate the deterninant of replace matrix
calculate_determinant20:
    la $t0,copy_coefficients_matrix2
# Load the matrix elements into registers
    # load the first row
    lb $t1, 0($t0)  # a11  a
    lb $t2, 1($t0)  # a12  b
    # load the second row
    lb $t3, 2($t0) # a21  c
    lb $t4, 3($t0) # a22  d
   
# Calculate the sub-determinants
    mul $t5, $t1, $t4  # a11 * a22
    mul $t6, $t2, $t3 # a12*a21
    sub $t8, $t5, $t6  # a22*a33 - a23*a32 ---> result
    jr $ra  # Return to the instruction after the jal
    
division_by_zero2:
	li $v0, 4  
	la $a0, error_msg  
	syscall

print_line20:
# Print a newline character
    li $a0, 10
    li $v0, 11
    syscall
    
j loop25

   
############## end of file #######
 # Close the file
    li $v0, 16                       # Close file syscall code
    move $a0, $s0                    # File descriptor to close
    syscall
    j End_Programe     
    
    
file_empty:
    li $v0, 4
    la $a0, fileEmpty                # Print empty file message
    syscall
    j End_Programe                           # Exit after showing message

error_input_file: 
	li $v0,55			        # code to call MessageDialog
	la $a0,openFail				# to call print message error
	la $a1,1
	syscall   
	j read_file    

End_Programe:	
    li $v0, 10                       # Exit syscall code
    syscall
