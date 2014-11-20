#include <square.h>
#include <math.h>

int square_num(int a) {
    return pow(a, 2);
}

int main(int argc, char *argv[])
{
    int number = 0;
    int number_squared = 0;

    printf("Enter a number: ");
    scanf("%d", &number);

    number_squared = square_num(number);

    printf("The square is %i\n", number_squared);

    return 0;
}
