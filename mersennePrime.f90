Program mersennePrime
!Type declarations
integer, dimension(8) :: primeNumbers
!Executable statements
primeNumbers = (/2, 3, 5, 7, 13, 17, 19, 31 /)
do i = 1, 8, 1
    call mPrime(primeNumbers(i))
end do
End program mersennePrime
!Subroutines
subroutine mPrime(n)
    integer :: n
    print *, 'The n value is:', n, 'and the calculated Mersenne Prime is:', 2**n-1
end subroutine mPrime
