//
// Multi-Bit Bang I2C library
// Copyright (c) 2019 BitBank Software, Inc.
// Written by Larry Bank (bitbank@pobox.com)
// Project started 1/1/2019
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
#ifndef __BITBANG_I2C__
#define __BITBANG_I2C__
//
// Read N bytes
//
int Multi_I2CRead(uint8_t iBus, uint8_t iAddr, uint8_t *pData, int iLen);
//
// Read N bytes starting at a specific I2C internal register
//
int Multi_I2CReadRegister(uint8_t iBus, uint8_t iAddr, uint8_t u8Register, uint8_t *pData, int iLen);
//
// Write I2C data
// quits if a NACK is received and returns 0
// otherwise returns the number of bytes written
//
int Multi_I2CWrite(uint8_t iBus, uint8_t iAddr, uint8_t *pData, int iLen);
//
// Scans for I2C devices on the bus
// returns a bitmap of devices which are present (128 bits = 16 bytes, LSB first)
// A set bit indicates that a device responded at that address
//
void Multi_I2CScan(uint8_t iBus, uint8_t *pMap);
//
// Initialize the I2C BitBang library
// Pass the pin numbers used for SDA and SCL
// as well as the clock rate in Hz
//
void Multi_I2CInit(uint8_t *iSDA_Pins, uint8_t *iSCL_Pins, int32_t *iClocks, uint8_t iCount);

#endif //__BITBANG_I2C__


