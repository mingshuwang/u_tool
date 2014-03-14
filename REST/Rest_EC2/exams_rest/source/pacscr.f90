subroutine PACSCR(IBUFF)
! This routine puts a set of intermediate computational variables into a
! compressed buffer and transmits it to a direct access scratch file.
! Author, Date: L.A. Burns, 06-Mar-84
! Revisions 10/22/88--run-time implementation of machine dependencies
! Revisions 31-Jan-2001 -- use allocatable storage based on actual size
use Implementation_Control
use Global_Variables
use Local_Working_Space
use Internal_Parameters
use Rates_and_Sums

! For the material to be transferred to the scratch file (all
! elements of labeled COMMON "SECTR1"), the number of single precision
! variables is: KOUNT*(4+47*KCHEM)
! and the number of double precision variables is: KOUNT*KCHEM*(2+KOUNT+KCHEM)
! Dimensioning of I/O transfer buffers to encompass (implicitly)
! the variables to be transferred:
Implicit None
real (kind(1.0e0)), allocatable, dimension(:) :: BUFF1
real (kind(1.0d0)), allocatable, dimension(:)  :: BUFF2

! Dimension the vector for information about the file:
integer :: IBUFF(VARIEC)

! Local counters etc.
integer :: I, J, K, NSP, NSTART, NEND
! NSP is used to count through chemical species vectors (e.g.
! SPFLGG). NSTART and NEND are the indices of the first and last
! member of BUFF written to each successive record, that is, these
! variables are used to match the transfer buffer with the end
! points of the output record.
integer :: OFFSET, NVAR, NRECS, FIRREC, LASTRC, ITRAIL
integer, dimension(7) :: IALPHA = (/1,5,9,13,17,21,25/)
! OFFSET is the number of records already used by previous file entries.
! NVAR is the number of variables in the current block of data.
! NRECS is the number of records used to contain the current block.
! FIRREC and LASTRC are the record numbers for the current block.
! ITRAIL is the number of variables in the last record of the block.
! IALPHA is addresses for alpha matrix.

allocate (BUFF1 ( KOUNT * (4+47*KCHEM)))
allocate (BUFF2 ( KOUNT * KCHEM * (2+KOUNT+KCHEM)))

! WRITE (*,*) 'WRITING FROM PACSCR: NDAT = ',NDAT
! WRITE (*,*) 'ALPHA: ', ALPHA
! WRITE (*,*) 'BIOLKL: ', BIOLKL
! WRITE (*,*) 'BIOTOL: ', BIOTOL
! WRITE (*,*) 'EXPOKL: ', EXPOKL
! WRITE (*,*) 'HYDRKL: ', HYDRKL
! WRITE (*,*) 'OXIDKL: ', OXIDKL
! WRITE (*,*) 'PHOTKL: ', PHOTKL
! WRITE (*,*) 'REDKL: ', REDKL
! WRITE (*,*) 'S1O2KL: ', S1O2KL
! WRITE (*,*) 'SEDCOL: ', SEDCOL
! WRITE (*,*) 'SEDMSL: ', SEDMSL
! WRITE (*,*) 'VOLKL: ', VOLKL
! WRITE (*,*) 'WATVOL: ', WATVOL
! WRITE (*,*) 'YSATL: ', YSATL
! WRITE (*,*) 'CONLDL: ', CONLDL
! WRITE (*,*) 'INTINL: ', INTINL
! WRITE (*,*) 'TOTKL: ', TOTKL
! WRITE (*,*) 'YIELDL: ', YIELDL
! Determine the number of records already in use, i.e., compute
! the offset needed for positioning the next blocks of data:
! First record reserved for file descriptors:
OFFSET = 1
if (NDAT > 1) OFFSET = 1+(NDAT-1)*(IBUFF(1)+IBUFF(3))
! Compress the single precision transfer buffer:
NVAR = 1 ! Load the counter for transferring real variables

Chemicals: do K = 1, KCHEM
   Segments: do J = 1, KOUNT
      Species: do NSP = 1, 7
         if (SPFLGG(NSP,K) == 0) cycle Species
         do I = IALPHA(NSP), IALPHA(NSP)+3
            BUFF1(NVAR) = ALPHA(I,J,K)
            NVAR = NVAR+1
         end do
      end do Species
      do I = 29, 32
         BUFF1(NVAR) = ALPHA(I,J,K)
         NVAR = NVAR+1
      end do
   end do Segments
end do Chemicals

do K = 1, KCHEM
   do J = 1, KOUNT
      BUFF1(NVAR) = BIOLKL(J,K)
      NVAR = NVAR+1
   end do
end do

do J = 1, KOUNT
   BUFF1(NVAR) = BIOTOL(J)
   NVAR = NVAR+1
end do

do K = 1, KCHEM
   do J = 1, KOUNT
      BUFF1(NVAR) = EXPOKL(J,K)
      NVAR = NVAR+1
   end do
end do

do K = 1, KCHEM
   do J = 1, KOUNT
      BUFF1(NVAR) = HYDRKL(J,K)
      NVAR = NVAR+1
   end do
end do

do K = 1, KCHEM
   do J = 1, KOUNT
      BUFF1(NVAR) = OXIDKL(J,K)
      NVAR = NVAR+1
   end do
end do

do K = 1, KCHEM
   do J = 1, KOUNT
      BUFF1(NVAR) = PHOTKL(J,K)
      NVAR = NVAR+1
   end do
end do

do K = 1, KCHEM
   do J = 1, KOUNT
      BUFF1(NVAR) = REDKL(J,K)
      NVAR = NVAR+1
   end do
end do

do K = 1, KCHEM
   do J = 1, KOUNT
      BUFF1(NVAR) = S1O2KL(J,K)
      NVAR = NVAR+1
   end do
end do

do J = 1, KOUNT
   BUFF1(NVAR) = SEDCOL(J)
   NVAR = NVAR+1
end do

do J = 1, KOUNT
   BUFF1(NVAR) = SEDMSL(J)
   NVAR = NVAR+1
end do

do K = 1, KCHEM
   do J = 1, KOUNT
      BUFF1(NVAR) = VOLKL(J,K)
      NVAR = NVAR+1
   end do
end do

do J = 1, KOUNT
   BUFF1(NVAR) = WATVOL(J)
   NVAR = NVAR+1
end do

do K = 1, KCHEM
   do J = 1, KOUNT
      Species_again: do NSP = 1, 7
         if (SPFLGG(NSP,K) == 0) cycle Species_again
         BUFF1(NVAR) = YSATL(NSP,J,K)
         NVAR = NVAR+1
      end do Species_again
   end do
end do

if (NDAT == 1) then
   ! On the first cycle, compute the actual number of records
   ! required to store the single-precision real variables, and
   ! the number of variables actually loaded in the last record.
   NVAR = NVAR-1
   ITRAIL = mod(NVAR,VARREC)
   NRECS = NVAR/VARREC
   if (ITRAIL /= 0) NRECS = NRECS+1
   IBUFF(1) = NRECS
   ! IBUFF(1) contains the total number of records needed to store
   ! the REAL*4 (single precision) variables.  IBUFF(2) gets the
   ! number of variables actually in the last record:
   IBUFF(2) = ITRAIL
   if (ITRAIL == 0) IBUFF(2) = VARREC
end if 
! Retrieve the file handler data
NRECS = IBUFF(1)
ITRAIL = IBUFF(2)

! Write out the buffer to the file up to (but not including) the last record:
FIRREC = OFFSET+1
LASTRC = FIRREC+NRECS-1
! WRITE (*,*)' Processing month number: ', NDAT
! WRITE (*,*)' PACSCR record numbers (REAL*4) encompass ', FIRREC
! WRITE (*,*)' through                                  ', LASTRC
! Set write index to point to first member of transfer buffer:
NSTART = 1
if (NRECS > 1) then
   NEND = VARREC            ! Set write termination index to length of records
   do K = FIRREC, LASTRC-1  ! Begin writing records
      write (WRKLUN,rec=K) (BUFF1(I),I=NSTART,NEND)
      NSTART = NEND+1          ! Update write indices to get
      NEND = NEND+VARREC       ! next sector of the buffer
   end do
end if
! Position the write index for the last active member of the buffer
NEND = (NRECS-1)*VARREC+ITRAIL
! WRITE (*,*)' FROM PACSCR: AT LAST RECORD FOR MONTH ',NDAT
! WRITE (*,*)' WE HAVE: NSTART = ',NSTART
! WRITE (*,*)'          NEND   = ',NEND
! WRITE (*,*)' for record number ',LASTRC
! Write the last (or the only) record:
write (WRKLUN,rec=LASTRC) (BUFF1(I),I=NSTART,NEND)

! Transfer real (kind (0D0)) variables
OFFSET = LASTRC
NVAR = 1         ! Reset the counter of variables actually loaded

do K = 1, KCHEM ! Compress the transfer buffer
   do J = 1, KOUNT
      BUFF2(NVAR) = CONLDL(J,K)
      NVAR = NVAR+1
   end do
end do

do K = 1, KCHEM
   do J = 1, KOUNT
      do I = 1, KOUNT
         BUFF2(NVAR) = INTINL(I,J,K)
         NVAR = NVAR+1
      end do
   end do
end do

do K = 1, KCHEM
   do J = 1, KOUNT
      BUFF2(NVAR) = TOTKL(J,K)
      NVAR = NVAR+1
   end do
end do

do J = 1, KOUNT
   do K = 1, KCHEM
      do I = 1, KCHEM
         BUFF2(NVAR) = YIELDL(I,K,J)
         NVAR = NVAR+1
      end do
   end do
end do
! If this is not the first cycle, skip requirements analysis.
First_cycle: if (NDAT == 1) then
   ! First cycle: compute the actual number of records required and
   ! the number of variables actually used in the last record; for
   ! the real (kind (0D0)) variables, only half as many can be loaded
   ! into each record.  This number is set in a Parameter statement;
   ! its name is VARDEC.
   NVAR = NVAR-1
   ! WRITE (*,*) ' Number of DP variables: ', NVAR
   ITRAIL = mod(NVAR,VARDEC)
   NRECS = NVAR/VARDEC
   if (ITRAIL /= 0) NRECS = NRECS+1
   IBUFF(3) = NRECS
   ! IBUFF(3) contains the total number of records needed to store
   ! the double precision (real (kind (0D0))) variables. IBUFF(4) gets the
   ! number of variables actually in the last record:
   IBUFF(4) = ITRAIL
   if (ITRAIL == 0) IBUFF(4) = VARDEC
   ! WRITE (*,*)' Number of DP records: ', IBUFF(3)
   ! WRITE (*,*)' Number of items in last record:' , IBUFF(4)
end if First_cycle
! Retrieve the file handler data
NRECS = IBUFF(3)
ITRAIL = IBUFF(4)
! Write out the buffer to the file up to (but not including) the last record
FIRREC = OFFSET+1
LASTRC = FIRREC+NRECS-1
! WRITE (*,*)' Processing month number: ', NDAT
! WRITE (*,*)' PACSCR record numbers (REAL*8) encompass ', FIRREC
! WRITE (*,*)' through                                  ', LASTRC
! Set write index to point to first member of transfer buffer:
NSTART = 1
if (NRECS > 1) then
   NEND = VARDEC            ! Set write termination index to length of records
   do K = FIRREC, LASTRC-1  ! Begin writing records
      !D WRITE (6,*)'Writing DP record number ', K
      write (WRKLUN,rec=K) (BUFF2(I),I=NSTART,NEND)
      NSTART = NEND+1       ! Update write indices to get
      NEND = NEND+VARDEC    ! next sector of the buffer
   end do
end if
! Position the write index for the last active member of the buffer:
NEND = (NRECS-1)*VARDEC+ITRAIL
! Write the last (or the only) record:
! WRITE (*,*) ' Writing last DP record, number ', LASTRC
! WRITE (*,*) ' First variable is number ', NSTART
! WRITE (*,*) ' Last variable is number ', NEND
write (WRKLUN,rec=LASTRC) (BUFF2(I),I=NSTART,NEND)
! Record the file descriptors:
if (NDAT == 1) write (WRKLUN,rec=1) (IBUFF(I),I=1,4)

deallocate (BUFF1,BUFF2)

return
end Subroutine PACSCR
