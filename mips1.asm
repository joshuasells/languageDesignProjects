.data
	operand1: .word 0
	operator: .word 0
	plus: .asciiz " + "
	subtract: .asciiz " - "
	multiply: .asciiz " * "
	mod: .asciiz " % "
	operand2: .word 0
	answer: .word 0
	myAnswer: .word 0
	numOfQuestions: .word 0
	numOfCorrectAnswers: .word 0
	numOfIncorrectAnswers: .word 0
	startMessage: .asciiz "Hello, welcome to MathQuiz, here is your first question:\n"
	correct: .asciiz "Correct!\n"
	incorrect: .asciiz "Incorrect!\n"
	firstPartOfQuestion: .asciiz "What is "
	questionMark: .asciiz "? "
	
	# end of program data
	firstPartOfResults: .asciiz "You solved "
	secondPartOfResults: .asciiz " math problems and got "
	thirdPartOfResults: .asciiz " correct and "
	fourthPartOfResults: .asciiz " incorrect, for a score of "
	percentageScore: .word 0
	fifthPartOfResults: .asciiz "%.\nThanks for playing!"
	
	
.text

.globl main

main:	
	# Greet the user
	li $v0, 4
	la $a0, startMessage
	syscall
	
askQuestion:
	# generate random int
	li $v0, 42
	li $a1, 21
	syscall
	# save int to memory
	sw $a0, operand1
	
	# generate random int
	li $v0, 42
	li $a1, 21
	syscall
	# save int to memory
	sw $a0, operand2
	
	# generate an int between 0 and 3 for representing an operator
	# generate random int
	li $v0, 42
	li $a1, 4
	syscall
	# save int to memory
	sw $a0, operator

	# Ask the question
	li $v0, 4
	la $a0, firstPartOfQuestion
	syscall
	
	li $v0, 1
	lw $a0, operand1
	syscall
	
	##### print out operator
	
	lw $t0, operator
	li $t1, 0
	li $t2, 1
	li $t3, 2
	li $t4, 3
	beq $t0, $t1, assignPlus
	beq $t0, $t2, assignSubtract
	beq $t0, $t3, assignMultiply
	beq $t0, $t4, assignMod
	
	assignPlus:
		li $v0, 4
		la $a0, plus
		syscall
		j assignOperatorsJumpBack
	assignSubtract:
		li $v0, 4
		la $a0, subtract
		syscall
		j assignOperatorsJumpBack
	assignMultiply:
		li $v0, 4
		la $a0, multiply
		syscall
		j assignOperatorsJumpBack
	assignMod:
		li $v0, 4
		la $a0, mod
		syscall
	
	
	
	assignOperatorsJumpBack:
	
	## end of print out the operator
	
	li $v0, 1
	lw $a0, operand2
	syscall
	
	# print question mark
	li $v0, 4
	la $a0, questionMark
	syscall
	
	
	

	# read an integer from the command line
	li $v0, 5
	syscall
	
	sw $v0, myAnswer #save the value the user typed in
	lw $s0, myAnswer # copy to the register
	li $s1, -1
	beq $s0, $s1, exit # if the user typed in -1, then exit the function
	
	
	# evaluate correct answer here
	jal evaluate
	
	lw $s2, answer # correct answer
	
 	beq $s0, $s2, printCorrect # if the user is correct, then let them know
	bne $s0, $s2, printIncorrect # if the user is wrong, then let them know 
	
	answerJumpBack:
	
	
	j askQuestion # recursively loop back to the start of askQuestion 
	
exit:
	# print out the results
	
	
	li $v0, 4
	la $a0, firstPartOfResults
	syscall
	
	#print out number of questions total
	li $v0, 1
	lw $a0, numOfQuestions
	syscall
	
	li $v0, 4
	la $a0, secondPartOfResults
	syscall
	
	# print out number of correct answers
	li $v0, 1
	lw $a0, numOfCorrectAnswers
	syscall
	
	li $v0, 4
	la $a0, thirdPartOfResults
	syscall
	
	#print out number of incorrect answers
	li $v0, 1
	lw $a0, numOfIncorrectAnswers
	syscall
	
	li $v0, 4
	la $a0, fourthPartOfResults
	syscall
	
	# print out result in percentage form
	lw $t0, numOfCorrectAnswers
	lw $t1, numOfQuestions
	li $t2, 100
	mul $t4, $t0, $t2
	div $t4, $t1
	mflo $t5
	sw $t5, percentageScore
	
	li $v0, 1
	lw $a0, percentageScore
	syscall
	
	li $v0, 4
	la $a0, fifthPartOfResults
	syscall
	
	# terminate the program
	li $v0, 10
	syscall
	
	
printCorrect:
	
	# print out the string "Correct!"
	li $v0, 4
	la $a0, correct
	syscall
	
	# increment numOfQuestion by 1
	lw $t0, numOfQuestions
	addiu $t0, $t0, 1
	sw $t0, numOfQuestions
	
	# increment numOfCorrectAnswers
	lw $t0, numOfCorrectAnswers
	addiu $t0, $t0, 1
	sw $t0, numOfCorrectAnswers
	
	j answerJumpBack # return
	
	
printIncorrect:
	# print out the string "Incorrect!"
	li $v0, 4
	la $a0, incorrect
	syscall
	
	# increment numOfQuestion by 1
	lw $t0, numOfQuestions
	addiu $t0, $t0, 1
	sw $t0, numOfQuestions
	
	# increment numOfIncorrectAnswers
	lw $t0, numOfIncorrectAnswers
	addiu $t0, $t0, 1
	sw $t0, numOfIncorrectAnswers
	
	j answerJumpBack
	
evaluate:
	lw $t0, operator
	li $t1, 0
	li $t2, 1
	li $t3, 2
	li $t4, 3
	lw $t5, operand1
	lw $t6, operand2
	beq $t0, $t1, evalPlus
	beq $t0, $t2, evalSubtract
	beq $t0, $t3, evalMultiply
	beq $t0, $t4, evalMod
	
	evalPlus:
		addu $t7, $t5, $t6
		sw $t7, answer
		j evalJumpBack
	evalSubtract:
		subu $t7, $t5, $t6
		sw $t7, answer
		j evalJumpBack
	evalMultiply:
		mul $t7, $t5, $t6
		sw $t7, answer
		j evalJumpBack
	evalMod:
		div $t5, $t6
		mfhi $t7
		sw $t7, answer
	
	evalJumpBack:
	
	jr $ra # go back, we are done here.
		
