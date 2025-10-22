//                                                                          //
//                 _              _                                         //
//              __| |  ___   ___ | |_  __ _  _ __    ___     ___            //
//             / _` | / _ \ / __|| __|/ _` || '_ \  / _ \   / __|           //
//            | (_| ||  __/| (__ | |_| (_| || |_) ||  __/ _| (__            //
//             \__,_| \___| \___| \__|\__,_|| .__/  \___|(_)\___|           //
//                                          |_|                             //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//            Copyright (c) 2019 by Bob Frazier and S.F.T. Inc.             //
//  Use, copying, and distribution of this software are licensed according  //
//  to the GPLv2, LGPLv2, or MIT-like license, as appropriate. See the      //
//  included 'LICENSE' and 'COPYING' files for more information.            //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////


// this program reads/writes FSM formatted magtape data

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdarg.h> /* stdarg to make sure I have va_list and other important stuff */
#include <unistd.h>
#include <string.h>
#include <ctype.h>
#include <dirent.h>
#include <fnmatch.h>
#include <sys/stat.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/param.h>
#include <time.h>


typedef union _RT11_VOL_HEADER_
{
  char buf[512]; // raw buffer

  struct
  {
    char    label_identifier[3];    // VOL
    char    label_number;           // typically '1'
    char    volume_identifier[6];   // volume name, 'RT11A ' typical, pad with ' '
    char    accessibility;          // ' '
    char    reserved26[26];         // 26 spaces
    char    owner_identifier[3];    // 'D%B' means tape written by DEC PDP-11
    char    owner_name[10];         // typically 10 spaces
    uint8_t DEC_standard_version;   // 1
    char    reserved28[28];         // 28 spaces
    uint8_t label_standard_version; // 3

    // rest of it is garbage
  } __attribute__((__packed__));

} RT11_VOL_HEADER;

#define SIZEOF_STRUCT_MEMBER(X,Y) sizeof(((X *)(0))->Y)

typedef union _RT11_FILE_HEADER_
{
  char buf[512]; // raw buffer

  struct
  {
    char    label_identifier[3];    // HDR
    char    label_number;           // typically '1'
    char    file_identifier[17];    // 6.3 file name, left justified, padded with ' '
    char    file_set_identifier[6]; // 'RT11A '
    char    file_section_number[4]; // '0001'
    char    file_sequence_number[4];// '0001' for first file, sequences upward
    char    generation_number[4];   // '0001'
    char    generation_version[2];  // '00'
    char    creation_date[6];       // ' YYddd' where YY is year (90) and 'ddd' is day in year (032) for example 2/1/1990
    char    expiration_date[6];     // ' 00000' indicates an expired file
    char    accessibility;          // ' '
    char    block_count[6];         // '000000'
    char    system_code[13];        // 'DECRT11A     '
    char    reserved7[7];           // 7 spaces

    // rest of it is garbage
  } __attribute__((__packed__));

} RT11_FILE_HEADER;

typedef union _RT11_FILE_EOF_
{
  char buf[512]; // raw buffer

  struct
  {
    char    label_identifier[3];    // EOF
    char    label_number;           // typically '1'
    char    file_identifier[17];    // 6.3 file name, left justified, padded with ' '
    char    file_set_identifier[6]; // 'RT11A '
    char    file_section_number[4]; // '0001'
    char    file_sequence_number[4];// '0001' for first file, sequences upward
    char    generation_number[4];   // '0001'
    char    generation_version[2];  // '00'
    char    creation_date[6];       // ' YYddd' where YY is year (90) and 'ddd' is day in year (032) for example 2/1/1990
    char    expiration_date[6];     // ' 00000' indicates an expired file
    char    accessibility;          // ' '
    char    block_count[6];         // 'nnnnnn' = # of 512 byte data blocks since the HDR record (0 if SPFUN used)
    char    system_code[13];        // 'DECRT11A     '
    char    reserved7[7];           // 7 spaces

    // rest of it is garbage
  } __attribute__((__packed__));

} RT11_FILE_EOF;

// TAPE FORMAT:
//
// * MARKER *
// VOLUME HEADER
// * MARKER*
//
// * MARKER *
// first file header
// * MARKER *
//
// \x00\x00\x00\x00 <-- data marker (?)
//
// * MARKER *
// data block (512 bytes)
// * MARKER *
//
// * MARKER *
// data block (512 bytes)
// * MARKER *
//
// ...  (tail end of file is padded with zero bytes)
//
// \x00\x00\x00\x00 <-- data marker (?)
//
// * MARKER *
// first file EOF
// * MARKER *
//
// \x00\x00\x00\x00 <-- data marker (?)
//
// (RINSE AND REPEAT FILE SEQUENCE FOR NEXT FILE)
//
// \x00\x00\x00\x00 <-- data marker (?)
//
// more zero bytes (end of tape)




uint8_t DATA_MARKER[4]={0, 0, 0, 0};
uint8_t TAPE_MARKER[4]={0, 2, 0, 0};

#define DEBUG_OUTPUT_WARN    (iVerbosity > 0)
#define DEBUG_OUTPUT_INFO    (iVerbosity > 1)
#define DEBUG_OUTPUT_CHATTY  (iVerbosity > 2)
#define DEBUG_OUTPUT_VERBOSE (iVerbosity > 3)

int iVerbosity = 0; // debug output

int QueryYesNo(const char *szMessage); // returns non-zero for yes, zero for no

int read_the_tape(FILE *pTape, const char *szTapeFileName, const char *pOutPath,
                  int bDirectory, int bOverwrite, int bConfirm, int bValidate, int bFindEndOfTape, int *piSeq);
int read_tape_block(FILE *pTape, void *pHeader); // always 512 byte blocks plus leading/trailing 'TAPE_MARKER'
int write_tape_block(FILE *pTape, void *pHeader); // always 512 byte blocks plus leading/trailing 'TAPE_MARKER'
int write_single_file_to_tape(FILE *pTape, const char *szFileName, int *pnFileSeqNum);
int write_the_tape(FILE *pTape, const char *pTapeFileName, const char *pInputName, int bAppend, int iDriveSize, const char *szLabel);

int days_since_year_start(int iYear, int iMonth, int iDay);
void mdy_from_days_since_year_start(int iYear, int nDays, int *piMonth, int *piDay);
void rt11_date(const char *pDate, int *piYear, int *piDayInYear);
const char *rt11_date_string(const char *pDate);
void format_rt11_file_name(const char *szSourceFile, char *pBuf, int cbBuf);

int do_initialize_tape(FILE *pTape, const char *szFileName, int iDriveSize, const char *pLabel);
int initialize_tape(const char *szFileName, int iDriveSize, int bOverwrite, const char *pLabel);

// file utilities (some are derived code from 'ForkMe')
int FileExists(const char *szFileName);
int IsDirectory(const char *szFileName);
int get_file_RT11_date_time(const char *szFileName, int *pnRTYear, int *pnRTDay);
int set_file_RT11_date_time(const char *szFileName, int nRTYear, int nRTDay);
void *WBAllocDirectoryList(const char *szDirSpec);
void WBDestroyDirectoryList(void *pDirectoryList);
int WBNextDirectoryEntry(void *pDirectoryList, char *szNameReturn, int cbNameReturn, unsigned long *pdwModeAttrReturn);



void usage()
{
  fputs("USAGE:\n"
        "  dectape -h\n"
        "  dectape [-v] tapefile\n"
        "  dectape tapefile directory\n"
        "  dectape directory tapefile\n"
        " where\n"
        " tapefile  a file that is (or will be) attached to a TMx device\n"
        " directory a directory to/from which to write files\n"
        " -h        prints this 'usage' message\n"
        " -v        Verbosity level (multiple -v to increase it)\n"
        " -n        do not overwrite existing files (the default)\n"
        " -o        DO overwrite existing files\n"
        " -q        Do not prompt to overwrite files or create a directory\n"
        " -V        validates a tape (rather than printing the directory)\n"
        " -A        append to the tape, rather than overwriting\n"
        "           (this can put duplicate file names on the tape)\n"
        " -I        Initialize a new tape file\n"
        " -S        Specify the size for a new tape file (in MB)\n"
        " -L        Specify the label for a new tape file\n"
        "\n"
        "To list the file directory of a tape, use\n"
        "    dectape tapefile\n"
        "\n"
        "To copy the tape files to a directory, use\n"
        "    dectape tapefile directory\n"
        "\n"
        "To copy a directory to a tape file, use\n"
        "    dectape directory tapefile\n"
        "\n"
        "This program is supposed to be simple.  No complaints.\n\n",
        stderr);
}

static char szTapeLabel[SIZEOF_STRUCT_MEMBER(RT11_VOL_HEADER,owner_name)] =
  { 'd','e','c','t','a','p','e',' ',' ',' ' };

int main(int argc, char *argv[])
{
FILE *pTape = NULL;
char *p1, *pEnd;
const char *p1C;
int i1, iRval;
int bDirectory = 1;
int bOverwrite = 0;
int bAppend = 0;
int bConfirm = 1;
int bValidate = 0;
int bInitialize = 0;
int iDriveSize = 32;


  // demo - do a directory of the tape

  // get options using 'getopt' so it behaves like every OTHER 'POSIX' utility
  while((i1 = getopt(argc, argv, "hvVqonAIS:L:"))
        != -1)
  {
    switch(i1)
    {
      case 'h':
        usage();
        exit(1);

      case 'v':
        iVerbosity++;
        break;

      case 'V':
        bValidate = 1;
        break;

      case 'q':
        bConfirm = 0;
        break;

      case 'n':
        bOverwrite = 0;
        break;

      case 'o':
        bOverwrite = 1;
        break;

      case 'A':
        bAppend = 1;
        break;

      case 'I':
        bInitialize = 1;
        break;

      case 'S':
        iDriveSize = atoi(optarg);
        break;

      case 'L':
        pEnd = &(szTapeLabel[sizeof(szTapeLabel)]);

        for(p1C=optarg, p1=szTapeLabel; *p1C && p1 < pEnd; )
        {
          *(p1++) = *(p1C++);
        }

        // pad with spaces
        while(p1 < pEnd)
        {
          *(p1++) = ' ';
        }

        break;
    }
  }

  argc -= optind;
  argv += optind;

  if(argc < 1)
  {
    usage();
    exit(1);
  }

  // see if one is a file, and one is a directory
  // if output file, make sure it does not exist unless 'overwrite'
  // if output dir, should it be empty??

  if(argc >= 2)
  {
    if(bInitialize)
    {
      fprintf(stderr, "Initialize does not take 2 parameters\n");
      usage();
      exit(1);
    }

    if(IsDirectory(argv[1]) && !IsDirectory(argv[0]))
    {
      bDirectory = 0; // a flag for later on
    }
    else if(!IsDirectory(argv[1]) && IsDirectory(argv[0]))
    {
      if(FileExists(argv[1]) && !bOverwrite && !bAppend && !QueryYesNo("Overwrite tape file"))
      {
        exit(0); // don't do it, but not an error either
      }

      if(bAppend && FileExists(argv[1]))
      {
        pTape = fopen(argv[1], "r+"); // open for read/write access
      }
      else
      {
        bAppend = 0; // because the file does not exist
        pTape = fopen(argv[1], "w"); // open for write access (destroying old one)
      }

      if(!pTape)
      {
        fprintf(stderr, "Unable to open tape file \"%s\"\n", argv[1]);
        exit(2);
      }

      iRval = write_the_tape(pTape, argv[1], argv[0], bAppend, iDriveSize, szTapeLabel);

      goto exit_point;
    }
    else
    {
      fputs("ERROR - file-to-file operations not (yet) supported\n", stderr);
      usage();
      exit(1);
    }
  }

  if(bInitialize)
  {
    // TODO:  warn if unnecessary params specified??

    return initialize_tape(argv[0], iDriveSize, bOverwrite, szTapeLabel);
  }

  // LIST TAPE DIRECTORY, VALIDATE, OR COPY TAPE TO DIRECTORY

  pTape = fopen(argv[0], "r");
  if(!pTape)
  {
    fprintf(stderr, "Unable to open tape file \"%s\"\n", argv[0]);
    exit(2);
  }

  iRval = read_the_tape(pTape, argv[0], (const char *)(bDirectory ? NULL : argv[1]),
                        bDirectory, bOverwrite, bConfirm, bValidate, 0, NULL);

exit_point:
  fclose(pTape);
  return iRval;
}

int QueryYesNo(const char *szMessage)
{
char tbuf[256];
int i1;

  while(!feof(stdin) && !ferror(stdin))
  {
    fprintf(stderr, "%s (y/n)?", szMessage);
    fgets(tbuf, sizeof(tbuf), stdin);

    // trim any trailing white space
    while((i1 = strlen(tbuf)) > 0 && tbuf[i1 - 1] <= ' ')
      tbuf[i1 - 1] = 0;

    // trim any lead white space
    while((i1 = strlen(tbuf)) > 0 && tbuf[0] <= ' ')
    {
      if(i1 > 1)
        memmove(tbuf, tbuf + 1, i1 - 1);

      tbuf[i1 - 1] = 0;
    }

    if(tbuf[0] == 'Y' || tbuf[0] == 'y')
      return 1;

    if(tbuf[0] == 'n' || tbuf[0] == 'N')
      return 0;

    fprintf(stderr, "Please respond with 'Y' or 'N'\n");
  }

  return 0; // for now (probably won't get here)
}



//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//                 _____                     ___     __ ___                 //
//                |_   _|__ _  _ __    ___  |_ _|   / // _ \                //
//                  | | / _` || '_ \  / _ \  | |   / /| | | |               //
//                  | || (_| || |_) ||  __/  | |  / / | |_| |               //
//                  |_| \__,_|| .__/  \___| |___|/_/   \___/                //
//                            |_|                                           //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////


int read_tape_block(FILE *pTape, void *pBlock)
{
uint8_t marker[4];  // where to read the markers into

  if(!pTape || feof(pTape))
    return -1;

  if(fread(marker, sizeof(marker), 1, pTape) != 1)
    return -2;

  if(!memcmp(marker, DATA_MARKER, sizeof(marker))) // end of tape
    return 1; // this is acceptable, but "an error" if I don't expect it

  if(memcmp(marker, TAPE_MARKER, sizeof(marker)))
    return -3; // missing tape marker

  if(feof(pTape) || fread(pBlock, 512, 1, pTape) != 1)
    return -4;

  if(feof(pTape) || fread(marker, sizeof(marker), 1, pTape) != 1)
    return -5;

  if(memcmp(marker, TAPE_MARKER, sizeof(marker)))
    return -6;

  return 0; // OK!
}

int write_tape_block(FILE *pTape, void *pBlock)
{
size_t lPos;

  if(!pTape)
    return -1;

  if(fwrite(TAPE_MARKER, 4, 1, pTape) != 1)  // write tape marker
    return -2;

  if(fwrite(pBlock, 512, 1, pTape) != 1)
    return -3;

  if(fwrite(TAPE_MARKER, 4, 1, pTape) != 1)
    return -4;

  lPos = ftell(pTape); // where am I right now?

  if(fwrite(DATA_MARKER, 4, 1, pTape) != 1 || // write two data markers here to mark EOT
     fwrite(DATA_MARKER, 4, 1, pTape) != 1)
    return -5;

  if(fseek(pTape, lPos, SEEK_SET) < 0) // re-position just before data marker
    return -6;

  return 0; // OK!
}

char *make_output_file_name(const char *pOutPath, const char *pFileIdentifier)
{
char *pRval;
int i1;
const char *p1, *p2, *pEnd;

  pRval = (char *)malloc(PATH_MAX * 2 + 256);
  if(!pRval)
    return NULL;

  strncpy(pRval, pOutPath, PATH_MAX);
  i1 = strlen(pRval);

  if(i1 > 0 && pRval[i1] != '/')
    strcat(pRval, "/");

  i1 = strlen(pRval);

  p1 = pFileIdentifier;  // up to 17

  pEnd = p1 + 17;

  while(*p1 && *p1 > ' ')
    p1++;

  p2 = p1;
  while(*p2 && p2 < pEnd && *p2 != '.')
    p2++;

  if(p1 > pFileIdentifier)
  {
    memcpy(pRval + i1, pFileIdentifier, p1 - pFileIdentifier);
    i1 +=  p1 - pFileIdentifier;
  }
  if(p2 < pEnd && *p2 == '.')
  {
    p1 = p2++;
    while(*p2 > ' ' && p2 < pEnd)
      p2++;

    if((p2 - p1) > 4)
    {
      memcpy(pRval + i1, p1, 4);
      i1 += 4;
    }
    else
    {
      memcpy(pRval + i1, p1, p2 - p1);
      i1 += p2 - p1;
    }
  }

  pRval[i1] = 0;

  return pRval;
}

FILE *do_open_output_file(const char *pOutPath, const char *pFileIdentifier, int bOverwrite, int bConfirm)
{
char *pFileName;
FILE *pRval;


  pFileName = make_output_file_name(pOutPath, pFileIdentifier);
  if(!pFileName)
    return NULL;

  if(FileExists(pFileName) && !bOverwrite)
  {
    if(bConfirm)
    {
      char tbuf[4096];
      snprintf(tbuf, sizeof(tbuf), "Overwrite \"%s\"", pFileName);

      if(!QueryYesNo(tbuf))
      {
        free(pFileName);
        return NULL;
      }
    }

    if(truncate(pFileName, 0)) // zero bytes long
    {
      fprintf(stderr, "Unable to write (truncate) to \"%s\", errno=%d (%xH)\n",
              pFileName, errno, errno);

      free(pFileName);
      return NULL;
    }
  }

  pRval = fopen(pFileName, "w");

  free(pFileName);
  return pRval;
}

int do_set_output_file_date_time(const char *pOutPath, const char *pFileIdentifier,
                                 const char * pCreationDate)
{
int iRval;
char *pFileName;
int iYear, iDay;

  pFileName = make_output_file_name(pOutPath, pFileIdentifier);
  if(!pFileName)
    return -1;

  rt11_date(pCreationDate, &iYear, &iDay);
  iRval = set_file_RT11_date_time(pFileName, iYear, iDay);

  free(pFileName);
  return iRval;
}


int read_the_tape(FILE *pTape, const char *szTapeFileName, const char *pOutPath,
                  int bDirectory, int bOverwrite, int bConfirm, int bValidate, int bFindEndOfTape, int *piSeq)
{
int iRval = -1, i1, nBlocks, iSeq, nBytesInLastBlock;
int bFoundTapeHeader = 0;
size_t lZeroedZZZ = 0L;
size_t lPos;
FILE *pOutFile;
RT11_VOL_HEADER vol;
RT11_FILE_HEADER file;
RT11_FILE_EOF eof;
uint8_t data[512]; // file data
uint8_t marker[4];  // where to read the markers into
char tbuf[512];


  iSeq = 0;

  if(piSeq)
    *piSeq = 0;

  fseek(pTape, 0, SEEK_SET); // this function only reads from the beginning of the tape

  i1 = read_tape_block(pTape, &vol); // read volume info

  if(i1 < 0)
  {
    fprintf(stderr, "Unable to read header on tape file \"%s\"\n", szTapeFileName);
    return -9;
  }

  if(i1 == 1) // empty tape
  {
    if(bFindEndOfTape)
    {
      fseek(pTape, 0, SEEK_SET);
      return 1; // to indicate 'empty tape'
    }

    // the tape is empty but I still want to output all of the things
    // that I normally would before I exit

    if(bValidate)
    {
      fputs("** NO VOLUME HEADER **\n", stdout);
    }

    if(bDirectory && !bValidate)
    {
      fputs("\nEND OF TAPE\n\n", stdout);
    }

    if(bValidate)
    {
      fputs("** TAPE VALIDATED **\n", stdout);
    }

    return 0;
  }

  if(!memcmp(vol.label_identifier, "HDR", 3))
  {
    memcpy(&file, &vol, sizeof(file));

    if(bValidate)
    {
      fputs("** NO VOLUME HEADER **\n", stdout);
    }

    bFoundTapeHeader = 0;
    goto do_file;
  }

  if(memcmp(vol.label_identifier, "VOL", 3) || vol.label_number != '1')
  {
    // TODO:  try again and see if this was a boot block?
    //        normally I wouldn't want to rely on a boot block without a volume header...

    fprintf(stderr, "Bad volume header - \"%-3.3s\" '%c'\n",
            vol.label_identifier, vol.label_number);

    return -8;
  }

  bFoundTapeHeader = 1;

  if((bDirectory || bValidate) && !bFindEndOfTape)
  {
    printf("RT11 TAPE  '%-3.3s' '%-10.10s' V%c Label V%c\n",
           vol.owner_identifier, vol.owner_name,
           vol.DEC_standard_version, vol.label_standard_version);
  }

  iSeq = -1; // as a flag, first time around

  while(!feof(pTape))
  {
    lPos = ftell(pTape); // position of the current header

    i1 = read_tape_block(pTape, &file); // read file directory 'HDR' info

    if(i1 > 0)
    {
      if(bDirectory && !bValidate && !bFindEndOfTape)
      {
        fputs("\nEND OF TAPE\n\n", stdout);
      }

      if(bFindEndOfTape)
      {
        // re-position file pointer back 4 bytes
        fseek(pTape, ftell(pTape) - 4, SEEK_SET);
      }

      if(iSeq < 0)  // first time through?
        iSeq = 0; // fix it back

      break;
    }
    else if(i1 < 0)
    {
      fprintf(stderr, "Unable to read file header at position %ld\n", (long)ftell(pTape) - 4);

      return -10;
    }
    else if(memcmp(file.label_identifier, "HDR", 3) || file.label_number != '1')
    {
      if(iSeq < 0 && memcmp(file.label_identifier, "HDR", 3)) // is it a boot block?
      {
        // for now assume this is a boot block

        if(bDirectory && !bFindEndOfTape)
        {
          fputs("  *BOOT BLOCK DETECTED*\n", stdout);
        }

        iSeq = 0;

        continue; // read it again
      }
      else
      {
        fprintf(stderr, "Invalid file header at position %ld - \"%-3.3s\" '%c'\n",
                (long)ftell(pTape) - 4,
                file.label_identifier, file.label_number);
      }

      return -10;
    }

    if(iSeq < 0) // first time through only, as a flag
      iSeq = 0;

do_file:
    iSeq++;

    if(piSeq)
      *piSeq = iSeq;

    if(DEBUG_OUTPUT_CHATTY)
      fprintf(stderr, "*INFO* - iSeq = %d\n", iSeq);

    memset(tbuf, 0, sizeof(tbuf));
    memcpy(tbuf, file.file_sequence_number, sizeof(file.file_sequence_number));

    lZeroedZZZ = 0L;

    if(iSeq == 1 && atoi(tbuf) == 0) // special case, 'ZEROED.ZZZ' file
    {
      if(!bFindEndOfTape)
        fputs("  ** FOUND ZEROED.ZZZ **\n", stdout);

      if(DEBUG_OUTPUT_CHATTY)
        fprintf(stderr, "*INFO* - ZEROED.ZZZ - iSeq = %d\n", iSeq);

      lZeroedZZZ = lPos; // keep track of where the HDR1 for ZEROED.ZZZ began

      iSeq = 0; // reset the sequence number to zero

      if(piSeq) // in case I return early
        *piSeq = iSeq;

      // there should be a block of 8 zero bytes, followed by the EOF
    }
    else if(iSeq != atoi(tbuf) && !bFindEndOfTape)
    {
      fprintf(stderr, "WARNING: Invalid file seq number in header - %d vs %d\n",
              iSeq, atoi(tbuf));
    }
    else if(iSeq == 1 && bDirectory && !bValidate && !bFindEndOfTape)
    {
      fputs("  FILE NAME         CREATE DATE  BLOCKS  TOTAL BYTES\n"
            "  ================  ===========  ======  ===========\n", stdout);
    }

    if(fread(marker, sizeof(marker), 1, pTape) != 1 ||
       memcmp(marker, DATA_MARKER, sizeof(marker))) // need a marker here
    {
      fprintf(stderr, "missing data marker at position %ld, file \"%-17.17s\"\n",
              (long)ftell(pTape) - 4,
              file.file_identifier);

      return -11;
    }

    if(lZeroedZZZ && // there should be one more data marker
       (fread(marker, sizeof(marker), 1, pTape) != 1 ||
        memcmp(marker, DATA_MARKER, sizeof(marker)))) // need a marker here
    {
      fprintf(stderr, "missing 2nd data marker at position %ld, file \"%-17.17s\"\n",
              (long)ftell(pTape) - 4,
              file.file_identifier);

      return -11;
    }

    if(pOutPath && !lZeroedZZZ)
    {
      pOutFile = do_open_output_file(pOutPath, file.file_identifier, bOverwrite, bConfirm);

      if(!pOutFile)
      {
        fprintf(stderr, "Unable to open \"%s/%-17.17s\" - errno=%d (%xH)\n",
                pOutPath, file.file_identifier, errno, errno);
      }
    }
    else
    {
      pOutFile = NULL; // a flag
    }

    nBlocks = 0;
    nBytesInLastBlock = 512; // initially

    while(!lZeroedZZZ && !feof(pTape))
    {
      lPos = ftell(pTape); // current position

      i1 = read_tape_block(pTape, data); // read file data block
      // see if it's an EOF header.  Yes, this is a LAME way of doing it, but that's
      // the way this thing works.

      if(i1 > 0) // a read error (TODO:  should >0 be used instead of 'above' sequence?
      {
        break; // end of file
      }
      else if(i1 < 0)
      {
        fprintf(stderr, "read error at position %ld, file \"%-17.17s\"\n",
                (long)lPos, file.file_identifier);

        return -7;
      }

      if(pOutFile)
      {
        if(fwrite(data, sizeof(data), 1, pOutFile) != 1)
        {
          fprintf(stderr, "ERROR - unable to write to \"%s/%-17.17s\" - errno=%d (%xH)\n",
                  pOutPath, file.file_identifier, errno, errno);

          // TODO:  do I quit?  just flag the error??
        }

        // figure out which byte is the last one without a 0 in it
        for(nBytesInLastBlock=512; nBytesInLastBlock > 0; nBytesInLastBlock--)
        {
          if(data[nBytesInLastBlock - 1] != 0)
            break;
        }
      }

      nBlocks++;
    }

    if(pOutFile)
    {
      fflush(pOutFile); // make sure I write it all first...

      if(nBlocks > 0 && nBytesInLastBlock < 512)
      {
        if(DEBUG_OUTPUT_CHATTY)
          fprintf(stderr, "truncating file \"%s/%-17.17s\" to %ld bytes\n",
                  pOutPath, file.file_identifier, (nBlocks - 1) * 512L + nBytesInLastBlock);

        // set file length to match the last block minus trailing 0 bytes
        ftruncate(fileno(pOutFile), (nBlocks - 1) * 512L + nBytesInLastBlock);
      }

      fclose(pOutFile);
      pOutFile = NULL;

      do_set_output_file_date_time(pOutPath, file.file_identifier, file.creation_date);
    }

    if(!lZeroedZZZ && bDirectory && !bValidate && !bFindEndOfTape)
    {
      // directory output
      printf("  %-17.17s  %-9.9s  %6d  %11ld\n",
             file.file_identifier,
             rt11_date_string(file.creation_date),
             nBlocks, (long)(nBlocks * 512));
    }

    i1 = read_tape_block(pTape, &eof); // read file EOF block

    if(i1 > 0)
    {
      printf("unexpected (missing EOF record)\nEND OF TAPE\n\n");

      if(lZeroedZZZ && bFindEndOfTape)
        fseek(pTape, lPos, SEEK_SET);

      return 1;
    }
    else if(i1 < 0 || memcmp(eof.label_identifier, "EOF", 3) || eof.label_number != '1')
    {
      if(i1 < 0)
        fprintf(stderr, "Unable to read EOF header at position %ld\n", lPos);
      else
        fprintf(stderr, "Invalid EOF header at position %ld - \"%-3.3s\" '%c'\n",
                lPos, eof.label_identifier, eof.label_number);

      return -12;
    }

    memset(tbuf, 0, sizeof(tbuf));
    memcpy(tbuf, eof.block_count, sizeof(eof.block_count)); // make sure tbuf is big enough

    if(memcmp(eof.file_identifier, file.file_identifier, sizeof(eof.file_identifier)) ||
       atoi(tbuf) != nBlocks)
    {
      if(!bFindEndOfTape)
        printf("    *EOF HEADER MISMATCH* \"%-17.17s\"  %s\n",
               eof.file_identifier, tbuf);
    }

    // there should be a data marker now

    if(fread(marker, sizeof(marker), 1, pTape) != 1)
    {
      fprintf(stderr, "missing data/tape marker at position %ld, file \"%-17.17s\"\n",
              (long)ftell(pTape) - 4,
              file.file_identifier);

      return -13;
    }

    if(memcmp(marker, DATA_MARKER, sizeof(marker))) // data marker means end of file should be next
    {
      printf("missing data marker at end of EOF record\n");

      return -14;
    }

    if(lZeroedZZZ && bFindEndOfTape)
    {
      if(fread(marker, sizeof(marker), 1, pTape) != 1 ||
         memcmp(marker, DATA_MARKER, sizeof(marker))) // need a marker here
      {
        fprintf(stderr, "missing 2nd data marker at position %ld, file \"%-17.17s\"\n",
                (long)ftell(pTape) - 4,
                file.file_identifier);

        return -14;
      }

      fseek(pTape, lPos, SEEK_SET); // position to just BEFORE the 'ZEROED.ZZZ' file header

      break;
    }
  }

  if(bValidate && !bFindEndOfTape)
    fputs("** TAPE VALIDATED **\n", stdout);

  if(piSeq)
    *piSeq = iSeq; // I'm returning the sequence number of the last file on the tape

  return 0; // success
}

int write_the_tape(FILE *pTape, const char *szTapeFileName, const char *szInputName, int bAppend, int iDriveSize, const char *szLabel)
{
int iRval = -1, iSeq=0, i1;
void *pD;
unsigned long dwMode;
char tbuf[PATH_MAX * 2], szDir[PATH_MAX];

  fseek(pTape, 0, SEEK_SET);

  if(!bAppend)
  {
initialize_tape_first:
    // initialize the tape file, extend to 32Mb, point just after the tape header

    iRval = do_initialize_tape(pTape, szTapeFileName, iDriveSize, szLabel);

    if(iRval)
    {
      return iRval;
    }
  }
  else
  {
    // read through the tape file until I get to the last file, and set the file pointer there
    // If the tape is not initialized, initialize it.

    iRval = read_the_tape(pTape, szTapeFileName, NULL, 0, 0, 0, 0, 1, &iSeq); // seeks to end of tape;
      // TODO:  need the sequence number of the last file - new param

    if(iRval > 0) // an uninitialized tape
    {
      fprintf(stderr, "WARNING - tape is empty, initializing...\n");
      goto initialize_tape_first;
    }
    else if(iRval)
    {
      fprintf(stderr, "ERROR - unable to find end of tape (aborting)\n");
      return iRval;
    }

    // right now iSeq should be the sequence number for the last file found
    // if there were NO files on the tape, however, it could be negative
    // TODO:  should I fix this??

    if(iSeq < 0) // can happen with an empty tape
      iSeq = 0;
  }

  // do a directory listing of the sub-directory 'pInputName' and write all of
  // the files that I find [that are not directories] to the tape, with upper case
  // 6.3 file names and RT11 date/times

  strncpy(szDir, szInputName, sizeof(szDir) - 8);

  i1 = strlen(szDir);

  if(szDir[i1 - 1] != '/')
    szDir[i1++] = '/';

  szDir[i1] = '*';
  szDir[i1 + 1] = '.';
  szDir[i1 + 2] = '*';
  szDir[i1 + 3] = 0;

  memcpy(tbuf, szDir, i1); // to build full file name when needed

  pD = WBAllocDirectoryList(szDir);
  if(!pD)
  {
    fprintf(stderr, "ERROR - unable to get directory list for \"%s\", errno=%d (%xH)\n",
            szDir, errno, errno);

    return -21;
  }

  iRval = 0;

  while(!WBNextDirectoryEntry(pD, tbuf + i1, sizeof(tbuf) - i1 - 1, &dwMode))
  {
    if(!S_ISDIR(dwMode) && !S_ISFIFO(dwMode) && !S_ISSOCK(dwMode) // don't copy these
       && !S_ISLNK(dwMode)) // for now I also skip symlinks
    {
      iRval = write_single_file_to_tape(pTape, tbuf, &iSeq);

      if(iRval)
        break;
    }
  }

  WBDestroyDirectoryList(pD);

  return iRval; // for now...
}

// NOTE:  on entry, '*pfnFileSeqNum' is the seq # for the last file on the tape,
//        or 0 if the tape is empty.  It is pre-incremented before assigning to
//        the next file written to the tape.
int write_single_file_to_tape(FILE *pTape, const char *szFileName, int *pnFileSeqNum)
{
int i1, i2, iRval = -999, nBlocks=0, nRTYear, nRTDay, cb1;
long lFileSize, nBytes;
FILE *pInput;
const char *p1, *p2, *pEnd;
RT11_FILE_HEADER file;
RT11_FILE_EOF eof;
uint8_t buf[512]; // file data
char tbuf[256];

  if(!FileExists(szFileName) || IsDirectory(szFileName))
    return -1; // file will not be copied onto the tape or does not exist any more

  pInput = fopen(szFileName, "r");
  if(!pInput)
  {
    fprintf(stderr, "ERROR opening file \"%s\" - errno=%d (%xH)\n",
            szFileName, errno, errno);

    return -2; // error opening file
  }

  // file is open.  build headers for it
  // TODO:  since name is restricted to 6.3 uppercase I need to keep track of the files that
  //        are already on the tape, and pick a new name as needed if there's already a match.
  //        BUT, for NOW, to expedite writing this, I'll just convert to upper case and truncate
  //        the name and put it on the tape as-is

  memset(&file, 0, sizeof(file));
  memcpy(file.label_identifier, "HDR", sizeof(file.label_identifier));
  file.label_number = '1';
  memcpy(file.file_set_identifier, "RT11A ", sizeof(file.file_set_identifier));
  memcpy(file.file_section_number, "0001", sizeof(file.file_section_number));

  (*pnFileSeqNum) ++; // increment first
  snprintf(tbuf, sizeof(tbuf), "%04d", *pnFileSeqNum);
  memcpy(file.file_sequence_number, tbuf, sizeof(file.file_sequence_number));

  format_rt11_file_name(szFileName, tbuf, sizeof(tbuf));
  memset(file.file_identifier, ' ', sizeof(file.file_identifier));
  memcpy(file.file_identifier, tbuf, 10); // always 10 bytes long

  memcpy(file.generation_version, "00", sizeof(file.generation_version));

  // get the file's date/time info as RT11 date/time, make it the 'creation date'
  get_file_RT11_date_time(szFileName, &nRTYear, &nRTDay); // this returns the year as YYYY not YY
  snprintf(tbuf, sizeof(tbuf), "%3d%03d", (nRTYear-1900)%1000, nRTDay);
  memcpy(file.creation_date, tbuf, sizeof(file.creation_date));

  memcpy(file.expiration_date, "000000", sizeof(file.expiration_date));
  file.accessibility = ' ';
  memcpy(file.block_count, "000000", sizeof(file.block_count));
  memcpy(file.system_code, "DECRT11A     ", sizeof(file.system_code));
  memset(file.reserved7, ' ', sizeof(file.reserved7));

  // NEXT, do the EOF header.  Most fields are duplicates of 'file'

  memcpy(&eof, &file, sizeof(eof));
  // eof fields that are different
  memcpy(eof.label_identifier, "EOF", 3);

  // start by writing the file header

  i1 = write_tape_block(pTape, &file);
  if(i1)
  {
    fprintf(stderr, "ERROR - write_tape_block() returns %d, errno=%d (%xH)\n",
            i1, errno, errno);

    iRval = i1;
    goto the_exit_point;
  }

  // next I must write a DATA_MARKER

  if(fwrite(DATA_MARKER, 4, 1, pTape) != 1) // write two data markers here to mark EOT
  {
data_marker_error:
    fprintf(stderr, "ERROR - can't write data marker, errno=%d (%xH)\n",
            errno, errno);

    iRval = -1;
    goto the_exit_point;
  }

  // next, read 512 byte blocks of the file and write them until I'm done reading it

  fseek(pInput, 0, SEEK_END);
  lFileSize = ftell(pInput);
  fseek(pInput, 0, SEEK_SET);

  nBlocks = (lFileSize + 511) / 512; // calc # of blocks that I'll need

  for(i1=0, nBytes=0; i1 < nBlocks; i1++, nBytes += 512)
  {
    memset(buf, 0, sizeof(buf));

    if(lFileSize > nBytes + 512)
    {
      cb1 = 512;
    }
    else
    {
      cb1 = (int)(lFileSize - nBytes);
    }

    i2 = fread(buf, cb1, 1, pInput);

    if(i2 != 1)
    {
      fprintf(stderr, "READ ERROR on input file \"%s\", i2=%d  errno=%d (%xH)\n",
              szFileName, i2, errno, errno);
      iRval = -2;

      goto the_exit_point;
    }

    i2 = write_tape_block(pTape, buf);
    if(i2)
    {
      fprintf(stderr, "ERROR - write_tape_block() returns %d, errno=%d (%xH)\n",
              i2, errno, errno);

      iRval = i2;
      goto the_exit_point;
    }
  }

  // next I must write a DATA_MARKER

  if(fwrite(DATA_MARKER, 4, 1, pTape) != 1) // write two data markers here to mark EOT
  {
    goto data_marker_error;
  }

  // update the block count and write EOF
  snprintf(tbuf, sizeof(tbuf), "%06d", nBlocks);
  memcpy(eof.block_count, tbuf, sizeof(eof.block_count));

  i1 = write_tape_block(pTape, &eof);
  if(i1)
  {
    fprintf(stderr, "ERROR - write_tape_block() returns %d, errno=%d (%xH)\n",
            i1, errno, errno);

    iRval = i1;
    goto the_exit_point;
  }

  if(fwrite(DATA_MARKER, 4, 1, pTape) != 1) // write two data markers here to mark EOT
  {
    goto data_marker_error;
  }

  iRval = 0;

the_exit_point:
  fclose(pInput);
  return iRval;
}

int do_initialize_tape(FILE *pTape, const char *szFileName, int iDriveSize, const char *pLabel)
{
int i1;
long lFileSize = 0, lTargetSize = 1024L * 1024L * iDriveSize, lPos;
RT11_VOL_HEADER *pHdr;
char buf[512]; // what I write from

  // build a header

  memset(buf, ' ', sizeof(buf)); // rather than zeros, use white space (no harm)

  pHdr = (RT11_VOL_HEADER *)buf;

  memcpy(pHdr->label_identifier, "VOL", sizeof(pHdr->label_identifier));
  pHdr->label_number = '1';
  memcpy(pHdr->volume_identifier, "RT11A ", sizeof(pHdr->volume_identifier));
  pHdr->accessibility = ' ';
  memset(pHdr->reserved26, ' ', sizeof(pHdr->reserved26));
  memcpy(pHdr->owner_identifier, "D%B", sizeof(pHdr->owner_identifier));
  memcpy(pHdr->owner_name, pLabel, sizeof(pHdr->owner_name));
  pHdr->DEC_standard_version = '1';
  memset(pHdr->reserved28, ' ', sizeof(pHdr->reserved28));
  pHdr->label_standard_version = '3';

  // tape marker, header, tape marker

  if((i1 = fwrite("\x00\x02\x00\x00", 4, 1, pTape)) != 1 ||
     (i1 = fwrite(buf, sizeof(buf), 1, pTape)) != 1 ||
     (i1 = fwrite("\x00\x02\x00\x00", 4, 1, pTape)) != 1)
  {
write_error:
    fprintf(stderr, "ERROR:  fwrite() returns %d, errno=%d (%xH)\n",
            i1, errno, errno);

    fclose(pTape);
    return -1;
  }

  lPos = ftell(pTape); // current file postion

  // always write at least one empty buffer minus the size of the marker * 2

  memset(buf, 0, sizeof(buf));

  if((i1 = fwrite(buf, sizeof(buf) - 8, 1, pTape)) != 1)
    goto write_error;

  lFileSize = sizeof(buf) * 2; // tape and marker and remaining 0 bytes

  while(lFileSize < lTargetSize)
  {
    if((i1 = fwrite(buf, sizeof(buf), 1, pTape)) != 1)
      goto write_error;

    lFileSize += sizeof(buf);
  }

  // set the file pointer to "right after the header"

  fseek(pTape, lPos, SEEK_SET);

  return 0; // I am done
}

int initialize_tape(const char *szFileName, int iDriveSize, int bOverwrite, const char *pLabel)
{
int iRval;
FILE *pTape;


  if(!pLabel || !*pLabel) // would be padded with white space if done right
    pLabel = "dectape   ";

  if(iDriveSize <= 0)
  {
    fprintf(stderr, "Invalid drive size %d\n", iDriveSize);

    usage();

    return -1;
  }

  // STEP 1:  does the file exist??

  if(FileExists(szFileName))
  {
    if(!bOverwrite && !QueryYesNo("Overwrite existing file"))
      return 1; // you said 'no'

    // make sure file is zero bytes long

    if(truncate(szFileName, 0)) // zero bytes long
    {
      fprintf(stderr, "Unable to write (truncate) to \"%s\", errno=%d (%xH)\n",
              szFileName, errno, errno);

      return -1;
    }
  }

  pTape = fopen(szFileName, "w");
  if(!pTape)
  {
    fprintf(stderr, "Unable to open \"%s\", errno=%d (%xH)\n",
            szFileName, errno, errno);

    return -1;
  }

  iRval = do_initialize_tape(pTape, szFileName, iDriveSize, pLabel);

  fclose(pTape);

  return iRval;
}

static const short aDays[13]=
{
  1,
  1 + 31,
  1 + 31 + 28,
  1 + 31 + 28 + 31,
  1 + 31 + 28 + 31 + 30,
  1 + 31 + 28 + 31 + 30 + 31,
  1 + 31 + 28 + 31 + 30 + 31 + 30,
  1 + 31 + 28 + 31 + 30 + 31 + 30 + 31,
  1 + 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31,
  1 + 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30,
  1 + 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31,
  1 + 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30,
  1 + 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30 + 31
};
static const short aDaysLeap[13]=
{
  1,
  1 + 31,
  1 + 31 + 29,
  1 + 31 + 29 + 31,
  1 + 31 + 29 + 31 + 30,
  1 + 31 + 29 + 31 + 30 + 31,
  1 + 31 + 29 + 31 + 30 + 31 + 30,
  1 + 31 + 29 + 31 + 30 + 31 + 30 + 31,
  1 + 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31,
  1 + 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31 + 30,
  1 + 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31,
  1 + 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30,
  1 + 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30 + 31
};

int days_since_year_start(int iYear, int iMonth, int iDay)
{
const short *pD;

  if((iYear % 400) == 0 ||
     ((iYear % 4) == 0 && (iYear % 100) != 0)) // leap year
  {
    pD = aDaysLeap;
  }
  else
  {
    pD = aDays;
  }

  if(iMonth >= 1 && iMonth <= 12)
    return pD[iMonth - 1] + iDay - 1;

  return 0; // an error, really
}

void mdy_from_days_since_year_start(int iYear, int nDays, int *piMonth, int *piDay)
{
const short *pD;

  if((iYear % 400) == 0 ||
     ((iYear % 4) == 0 && (iYear % 100) != 0)) // leap year
  {
    pD = aDaysLeap;
  }
  else
  {
    pD = aDays;
  }

  for(*piMonth=1; *piMonth < 12; (*piMonth)++) // month is 1-based, as is day in year
  {
    if(nDays < pD[*piMonth]) // found entry with more days than current one
      break;
  }

  *piDay = 1 + nDays - pD[*piMonth - 1]; // day is also 1-based

  if(*piMonth < 1 || *piMonth > 12 || *piDay < 1 || *piDay > 31)
  {
    fprintf(stderr, "ERROR - insane month/days from year start:  iYear=%d  nDays=%d  iMonth=%d  iDay=%d\n",
            iYear, nDays, *piMonth, *piDay);
  }
}

void rt11_date(const char *pDate, int *piYear, int *piDayInYear)
{
int iYear, iDay;

  // ignore first character if it's a space, otherwise # of years since 1900
  // format the date from the following information:
  //
  // YYYddd  where 'YYY' is years since 1900, and 'ddd' is days since Jan 1 (inclusive)

  if(*pDate >= '0' && *pDate <= '9')
    iYear = 1900 + 100 * (*pDate - '0');
  else
    iYear = 1900;

  iYear += 10 * (pDate[1] - '0') + (pDate[2] - '0');

  iDay = 100 * (pDate[3] - '0')
       + 10 * (pDate[4] - '0')
       + (pDate[5] - '0');

  if(iDay < 1 || iDay > 366)
  {
    fprintf(stderr, "ERROR - insane 'day' value: \"%s\" --> iYear=%d, iDay=%d\n",
            pDate, iYear, iDay);
  }

  if(piYear)
    *piYear = iYear;

  if(piDayInYear)
    *piDayInYear = iDay;
}

const char *rt11_date_string(const char *pDate)
{
int iYear, iDay, iMonth;
static char szRval[16];
static const char * const aszMonthNames[13]=
{
  "???","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"
};

  rt11_date(pDate, &iYear, &iDay);
  mdy_from_days_since_year_start(iYear, iDay, &iMonth, &iDay);

  if(iDay < 1 || iDay > 30 || iMonth < 1 || iMonth > 12)
  {
    fprintf(stderr, "ERROR - insane dates - \"%s\" --> iYear=%d, iMonth=%d iDay=%d\n",
            pDate, iYear, iMonth, iDay);
  }

  snprintf(szRval, sizeof(szRval), "%02d-%s-%02d",
           (iDay % 100),
           aszMonthNames[iMonth], // 1-based month
           (iYear % 100));

  return szRval;
}


void format_rt11_file_name(const char *szSourceFile, char *pBuf, int cbBuf)
{
int i1;
const char *p1c;
char *p1, *p2;
char tbuf[64];
char name[7];
char ext[4];

  memset(tbuf, 0, sizeof(tbuf));

  // the filename must be a 6.3 name, upper case.
  p1c = strrchr(szSourceFile, '/'); // if it has a directory in it, find the '/'
  if(p1c)
    p1c++;
  else
    p1c = szSourceFile;

  memset(tbuf, 0, sizeof(tbuf));
  memset(name, 0, sizeof(name));
  memset(ext, 0, sizeof(ext));

  strncpy(tbuf, p1c, sizeof(tbuf)-1);

  // convert to upper case.  Name must be RAD50 char, 0-9 A-Z $ ? or space,
  // in the format NNNNNN.EEE  with trailing white space to justify

  p1 = tbuf;
  while(*p1 && *p1 != '.')
  {
    char c1 = toupper(*p1);
    if((c1 < '0' && c1 > '9') &&
       (c1 < 'A' && c1 > 'Z') &&
       (c1 != '$' && c1 != '?' && c1 != ' '))
    {
      c1 = '?'; // sub in '?' for bad chars
    }

    *(p1++) = c1;
  }

  i1 = p1 - tbuf;
  if(i1 > 6)
    i1 = 6;

  if(i1 > 0)
    memcpy(name, tbuf, i1);

  if(i1 < 6)
    memset(name + i1, ' ', 6 - i1);

  name[6] = 0;

  if(!*p1)
  {
    fputs("SHIT\n",stderr);
    p2 = p1;
  }
  else
  {
    p1++;
    p2 = p1;

//    fprintf(stderr, "    HERE:  \"%s\"\n", p1);

    while(*p1)
    {
      char c1 = toupper(*p1);
      if((c1 < '0' && c1 > '9') &&
         (c1 < 'A' && c1 > 'Z') &&
         (c1 != '$' && c1 != '?' && c1 != ' '))
      {
        c1 = '?'; // sub in '?' for bad chars
      }

      *(p1++) = c1;
    }

//    fprintf(stderr, "    HERE:  \"%s\" len=%d\n", p2, p1 - p2);
  }

  i1 = p1 - p2;
  if(i1 > 3)
    i1 = 3;

  if(i1 > 0)
    memcpy(ext, p2, i1);

  if(i1 < 3)
    memset(ext + i1, ' ', 3 - i1);

  ext[3] = 0;

//  fprintf(stderr, "    TEMPORARY:  %s becomes \"%s.%s\"\n",
//          szSourceFile, name, ext);

  // format file name into output buffer

  if(cbBuf > 6)
  {
    memcpy(pBuf, name, 6);
    pBuf += 6;
    cbBuf -= 6;
  }
  else if(cbBuf > 0)
  {
    memcpy(pBuf, name, cbBuf);
    cbBuf = 0;
  }

  if(cbBuf > 0)
  {
    *(pBuf++) = '.';
    cbBuf --;
  }

  if(cbBuf > 3)
  {
    memcpy(pBuf, ext, 3);
    pBuf += 3;
    cbBuf -= 3;
  }
  else if(cbBuf > 0)
  {
    memcpy(pBuf, ext, cbBuf);
    cbBuf = 0;
  }

  if(cbBuf > 0)
    *pBuf = 0;
}


// FILE UTILITIES
// Some of these were derived from 'ForkMe' - http://github.com/bombasticbob/ForkMe
// that utility is covered by the same type of license, and was written by the same author as 'dectape'

#define WBAlloc(X) malloc(X)
#define WBReAlloc(X,Y) realloc(X,Y)
#define WBFree(X) free(X)

int FileExists(const char *szFileName)
{
struct stat sb;

  return !stat(szFileName, &sb);
}

int IsDirectory(const char *szFileName)
{
struct stat sb;

  // NOTE:  this returns info about symlink targets if 'szFileName' is a symlink

  return !stat(szFileName, &sb) &&
         S_ISDIR(sb.st_mode);
}

// NOTE:  year is returned as YYYY not YY, so subtract 1900 - then 2000 becomes 100, etc.
int get_file_RT11_date_time(const char *szFileName, int *pnRTYear, int *pnRTDay)
{
struct stat st;
struct tm *pTM;
time_t tmFile;


  if(*pnRTYear)
    *pnRTYear = 0;
  if(*pnRTDay)
    *pnRTDay = 0;

  if(stat(szFileName, &st))
  {
    fprintf(stderr, "Unable to 'stat' \"%s\", errno=%d (%xH)\n",
            szFileName, errno, errno);
    return -1;
  }

  tmFile = (time_t)st.st_mtim.tv_sec; // get the time_t value; next I'll want to conver to a date

  pTM = localtime(&tmFile);

  if(!pTM)
    return -1;

  if(pnRTDay)
    *pnRTDay = days_since_year_start(pTM->tm_year + 1900, pTM->tm_mon + 1, pTM->tm_mday);

  if(pnRTYear)
    *pnRTYear = pTM->tm_year + 1900;

  return 0;
}

int set_file_RT11_date_time(const char *szFileName, int nRTYear, int nRTDay)
{
struct timeval tms[2];
struct tm tm1;
int iMonth, iDay;


  mdy_from_days_since_year_start(nRTYear, nRTDay, &iMonth, &iDay);

  memset(&tm1, 0, sizeof(tm1));
  tm1.tm_mday = iDay;
  tm1.tm_mon = iMonth - 1;
  tm1.tm_year = nRTYear - 1900;

  memset(tms, 0, sizeof(tms));
  tms[0].tv_sec = tms[1].tv_sec = mktime(&tm1);

  if(DEBUG_OUTPUT_CHATTY)
    fprintf(stderr, "File:  \"%s\" - set RT11 date %d.%d %04d-%02d-%02d  %ld\n",
            szFileName, nRTYear, nRTDay, nRTYear, iMonth, iDay, tms[0].tv_sec);

  return utimes(szFileName, &(tms[0]));
}

typedef struct __DIRLIST__
{
  const char *szPath, *szNameSpec;
  DIR *hD;
  struct stat sF;
  union
  {
    char cde[sizeof(struct dirent) + NAME_MAX + 2];
    struct dirent de;
  };
// actual composite 'search name' follows
} DIRLIST;

void *WBAllocDirectoryList(const char *szDirSpec)
{
DIRLIST *pRval;
char *p1, *p2;
int iLen, nMaxLen;
char *pBuf;

  if(!szDirSpec || !*szDirSpec)
  {
    if(DEBUG_OUTPUT_WARN)
      fprintf(stderr, "WARNING - %s - invalid directory (NULL or empty)\n", __FUNCTION__);
    return NULL;
  }

  iLen = strlen(szDirSpec);
  nMaxLen = iLen + 32;

  pBuf = WBAlloc(nMaxLen);
  if(!pBuf)
  {
    fprintf(stderr, "ERROR - %s - Unable to allocate memory for buffer size %d\n", __FUNCTION__, nMaxLen);
    return NULL;
  }

  if(szDirSpec[0] == '/') // path starts from the root
  {
    memcpy(pBuf, szDirSpec, iLen + 1);
  }
  else // for now, force a path of './' to be prepended to path spec
  {
    pBuf[0] = '.';
    pBuf[1] = '/';

    memcpy(pBuf + 2, szDirSpec, iLen + 1);
    iLen += 2;
  }

  // do a reverse scan until I find a '/'
  p1 = ((char *)pBuf) + iLen;
  while(p1 > pBuf && *(p1 - 1) != '/')
  {
    p1--;
  }

  if(DEBUG_OUTPUT_CHATTY)
  {
    fprintf(stderr, "Allocate Directory List:  \"%s\" \"%s\" \"%s\"\n", pBuf, p1, szDirSpec);
  }

  if(p1 > pBuf)
  {
    // found, and p1 points PAST the '/'.  See if it ends in '/' or if there are wildcards present
    if(!*p1) // name ends in '/'
    {
      if(p1 == (pBuf + 1) && *pBuf == '/') // root dir
      {
        p1++;
      }
      else
      {
        *(p1 - 1) = 0;  // trim the final '/'
      }

      p1[0] = '*';
      p1[1] = 0;
    }
    else if(strchr(p1, '*') || strchr(p1, '?'))
    {
      if(p1 == (pBuf + 1) && *pBuf == '/') // root dir
      {
        memmove(p1 + 1, p1, strlen(p1) + 1);
        *(p1++) = 0; // after this, p1 points to the file spec
      }
      else
      {
        *(p1 - 1) = 0;  // p1 points to the file spec
      }
    }
    else if(IsDirectory(pBuf)) // entire name is a directory
    {
      // NOTE:  root directory should NEVER end up here

      p1 += strlen(p1);
      *(p1++) = 0; // end of path (would be '/')
      p1[0] = '*';
      p1[1] = 0;
    }
    else if(DEBUG_OUTPUT_WARN)
    {
      fprintf(stderr, "allocating directory list, but I am confused, %s %s\n", pBuf, p1);
    }
  }
  else
  {
    // this should never happen if I'm always prepending a './'
    // TODO:  make this more consistent, maybe absolute path?

    if(DEBUG_OUTPUT_WARN)
      fprintf(stderr, "Allocating directory list:  should not happen, %s %s\n", pBuf, p1);

    if(strchr(pBuf, '*') || strchr(pBuf, '?')) // wildcard spec
    {
      p1 = (char *)pBuf + 1; // make room for zero byte preceding dir spec
      memmove(pBuf, p1, iLen + 1);
      *pBuf = 0;  // since it's the current working dir just make it a zero byte (empty string)
    }
    else if(IsDirectory(pBuf))
    {
      p1 = (char *)pBuf + iLen;
      *(p1++) = 0; // end of path (would be '/')
      p1[0] = '*';
      p1[1] = 0;
    }
  }

  pRval = WBAlloc(sizeof(DIRLIST) + iLen + strlen(p1) + 2);

  if(pRval)
  {
    pRval->szPath = pBuf;
    pRval->szNameSpec = p1;

    p2 = (char *)(pRval + 1);
    strcpy(p2, pBuf);
    p2 += strlen(p2);
    *(p2++) = '/';
    strcpy(p2, p1);
    p1 = (char *)(pRval + 1);

    pRval->hD = opendir(pBuf);

    if(DEBUG_OUTPUT_VERBOSE)
      fprintf(stderr, "Allocating directory list - opendir for %s returns %p\n", pBuf, pRval->hD);

    if(pRval->hD == NULL)
    {
      if(DEBUG_OUTPUT_WARN)
        fprintf(stderr, "WARNING - %s - Unable to open dir \"%s\", errno=%d\n", __FUNCTION__, pBuf, errno);

      WBFree(pBuf);
      WBFree(pRval);

      pRval = NULL;
    }
  }
  else
  {
    fprintf(stderr, "ERROR - %s - Unable to allocate memory for DIRLIST\n", __FUNCTION__);
    WBFree(pBuf);  // no need to keep this around
  }

  return pRval;
}

void WBDestroyDirectoryList(void *pDirectoryList)
{
  if(pDirectoryList)
  {
    DIRLIST *pD = (DIRLIST *)pDirectoryList;

    if(pD->hD)
    {
      closedir(pD->hD);
    }
    if(pD->szPath)
    {
      WBFree((void *)(pD->szPath));
    }

    WBFree(pDirectoryList);
  }
}

// returns < 0 on error, > 0 on EOF, 0 for "found something"

int WBNextDirectoryEntry(void *pDirectoryList, char *szNameReturn,
                         int cbNameReturn, unsigned long *pdwModeAttrReturn)
{
struct dirent *pD;
struct stat sF;
char *p1, *pBuf;
//static char *p2; // temporary
int iRval = 1;  // default 'EOF'
DIRLIST *pDL = (DIRLIST *)pDirectoryList;


  if(!pDirectoryList)
  {
    return -1;
  }

  // TODO:  improve this, maybe cache buffer or string length...
  pBuf = WBAlloc(strlen(pDL->szPath) + 8 + NAME_MAX);

  if(!pBuf)
  {
    return -2;
  }

  strcpy(pBuf, pDL->szPath);
  p1 = pBuf + strlen(pBuf);
  if(p1 > pBuf && *(p1 - 1) != '/') // it does not already end in /
  {
    *(p1++) = '/';  // for now assume this
    *p1 = 0;  // by convention
  }

  if(pDL->hD)
  {
    while((pD = readdir(pDL->hD))
          != NULL)
    {
      // skip '.' and '..'
      if(pD->d_name[0] == '.' &&
         (!pD->d_name[1] ||
          (pD->d_name[1] == '.' && !pD->d_name[2])))
      {
        if(DEBUG_OUTPUT_CHATTY)
          fprintf(stderr, "%s.%d:  skipping %s\n", __FUNCTION__, __LINE__, pD->d_name);
        continue;  // no '.' or '..'
      }

      strcpy(p1, pD->d_name);

      if(!lstat(pBuf, &sF)) // 'lstat' returns data about a file, and if it's a symlink, returns info about the link itself
      {
        if(!fnmatch(pDL->szNameSpec, p1, 0/*FNM_PERIOD*/))  // 'tbuf2' is my pattern
        {
          iRval = 0;

          if(pdwModeAttrReturn)
          {
            *pdwModeAttrReturn = sF.st_mode;
          }

          if(szNameReturn && cbNameReturn > 0)
          {
            strncpy(szNameReturn, p1, cbNameReturn);
          }

          break;
        }
        else if(DEBUG_OUTPUT_CHATTY)
        {
          fprintf(stderr, "DEBUG:  \"%s\" does not match \"%s\"\n", p1, pDL->szNameSpec);
        }
      }
      else
      {
        if(DEBUG_OUTPUT_WARN)
          fprintf(stderr, "%s: can't 'stat' %s, errno=%d (%08xH)\n", __FUNCTION__, pBuf, errno, errno);
      }
    }
  }

  if(pBuf)
  {
    WBFree(pBuf);
  }

  return iRval;

}

