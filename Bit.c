/************************************************************************************************
 *																								*
 *								Project Name : C Bit Operation									*
 *																								*
 *								File Name : Bit.c												*
 *																								*
 *								Programmer : Lin Yunqi											*
 *																								*
 *								Student ID : 18722016											*
 *																								*
 *								Last Update : 2020 / 6 / 18										*
 *																								*
 *--------------------------------------------------------------------------------------------- */



#include<stdio.h>

unsigned int n;

void Q1();
void Q2();
void Q3();
void Q4();
void Q5();
void print(unsigned int num);


void main() {
	printf("input a number:");
	while (1) {
		scanf("%d", &n);
		Q1();
		Q2();
		Q3();
		Q4();
		Q5();
		printf("\ninput a number:");
	}
}

void print(unsigned int num) {
	int index = 0;
	int arr[32];//array to store the binary
	for (int i = 0; i < 32; i++)
		arr[i] = 0;
	while (num) {
		if (num & 1) {
			arr[index++] = 1;
		}
		else {
			arr[index++] = 0;
		}
		num >>= 1;
	}

	for (int i = 31; i >= 0; i--) {
		printf("%d", arr[i]);
	}

}

void Q1() {
	//Q1. Print the number of bit 1 for this integer and all bits 

	int i = 0, index = 0; //counter
	int input = n;
	int arr[32];//array to store the binary
	for (int i = 0; i < 32; i++)
		arr[i] = 0;

	/*
	convert the decimal into binary and store it in an array in an inverted order
	*/
	while (input) {
		if (input & 1) {
			arr[index++] = 1;
			i++;
		}
		else {
			arr[index++] = 0;
		}
		input >>= 1;
	}

	printf("The number of bit 1 is:       %d\nThe bits for this integer is: ", i);


	for (int i = 31; i >= 0; i--) {
		printf("%d", arr[i]);
	}

	printf("\n");
}

void Q2() {
	//Q2. Exchange the lower 4 bits and higher 4 bits, and print all bits

	unsigned int input = n;



	/*
	exchange the bits
	*/
	unsigned int a = (input << 28) | (input >> 28);
	unsigned int b = input << 4;
	b >>= 8;
	b <<= 4;
	unsigned int result = a | b;

	printf("The exchanged bits are:       ");

	print(result);


	printf("\n");

}

void Q3() {
	//Print the even bits series 

	printf("Print the even bits series:   ");

	unsigned int input = n >> 1;//omit the first bit
	int index = 0;
	int arr[32];//array to store the binary
	for (int i = 0; i < 32; i++)
		arr[i] = 0;

	while (input) {
		if (input & 1) {
			arr[index++] = 1;
		}
		else {
			arr[index++] = 0;
		}
		input >>= 2;//shift to the bit after the next bit
	}

	for (int i = 15; i >= 0; i--) {
		printf("%d ", arr[i]);
	}



	printf("\n");

}

void Q4() {
	// Change bit 7-10 status and print all bits of this number after change 
	unsigned int input = n;
	unsigned int a = 0x0f;
	a <<= 7;
	unsigned result = input ^ a;
	printf("After change 7-10:            ");
	print(result);



	printf("\n");

}

void Q5() {
	//Set the bit 4, clear bit 3, and print all bits of this number after change 
	unsigned int input = n;
	unsigned int a = 0xfffffff7;
	unsigned int b = 0x00000010;
	unsigned result = input & a;
	result = result | b;
	printf("Set the bit 4, clear bit 3:   ");
	print(result);



	printf("\n");
}