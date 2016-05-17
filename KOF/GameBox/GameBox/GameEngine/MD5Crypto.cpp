//
//  MD5Crypto.cpp
//  GameBox
//
//  Created by Mac on 13-5-23.
//
//

#include "MD5Crypto.h"
#include "CCCrypto.h"
#include <iostream>

using namespace ptola::io;
USING_NS_CC_EXT;

const char *CMD5Crypto::md5(const char *lpcszSource, unsigned int uLength)
{
    unsigned char outPutStr[16] = {0};
    
    unsigned char outPutStr2[32] = {0};
    
    CCCrypto::MD5((void *)lpcszSource, uLength, outPutStr);
    
    for (int i = 0; i<16; i++)
    {
        outPutStr2[i*2]   = (outPutStr[i]>>4) &  15;
        outPutStr2[i*2+1] =  outPutStr[i]   &  15;
    }
    static char tempBuffer[33]={0};
    
    for (int i=0; i<32; i++)
    {
        sprintf(&tempBuffer[i], "%x",outPutStr2[i] );
    }
    
    
    
    const char *retChar = (const char *)tempBuffer;
    
    return retChar;
}




