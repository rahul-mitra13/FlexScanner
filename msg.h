/*
 * msg.h -- List of messages for P- compiler
 *
 * Rahul Mitra
 *
 * Date: 28th September, 2019
 * Assignment 2, CPSC316
 *
 */

/* Some error definitions for the scanner */
#define mnKeywordFound                     0
#define mnUnknownChar                      1
#define mnIllegalString                    2
#define mnInteger                          3
#define mnFloat                            4
#define mnIdentifier                       5
#define mnLegalString                      6
#define mnSimpleOperator                   7
#define mnCompoundOperator                 8
#define mnIllegalComment                   9

/* Actual messages */
static char *message[] = {
    "%s: %d: keyword '%s' found\n",
    "%s: %d: unknown character %#x\n",
    "%s: %d: illegal string %s found\n",
    "%s: %d: integer %s found\n",
    "%s: %d: float %s found\n",
    "%s: %d: identifier %s found\n",
    "%s: %d: string %s found\n",
    "%s: %d: simple operator %s found\n",
    "%s: %d: compound operator %s found\n",
    "%s: %d: illegal Comment %s found\n",
};
