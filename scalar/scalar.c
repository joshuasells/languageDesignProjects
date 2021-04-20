#include <stdio.h>
#include <string.h>

int main()
{
    // Prompt user to enter a text filename
    printf("What file would you like to load a 5 x 5 matrix from?\n");
    // Store the result in the string variable: file_string
    char file_string[20];
    scanf("%s", file_string);


    // Create a file object
    FILE *in_file;
    char buf[1000];

    // Open the file for read mode
    in_file = fopen(file_string,"r");
    // Terminate the program if the the filename is invalid

    if (!in_file) {
        printf("The filename is invalid");
        return 1;
    }

    // Prompt user to enter a integer to multiply against the matrix.
    printf("Enter the scaler value:\n");
    // Store the result in the integer multiplier.
    int mult;
    scanf("%d", &mult);

    printf("Results:");

    // Read each integer and multiply it by the scaler multiplier.
    // Then assign it into a 5x5 2d array.
    int matrix[5][5];
    // Set counter variables for the loops.
    int i, j;
    for (i = 0; i < 5; i++) {
        printf("\n");
        for (j = 0; j < 5; j++) {
            fscanf(in_file, "%d", &matrix[i][j]);
            matrix[i][j] = matrix[i][j] * mult;
            printf("%d ", matrix[i][j]);
        }
    }

    // Close the file and terminate program
    fclose(in_file);
    return 0;
}
