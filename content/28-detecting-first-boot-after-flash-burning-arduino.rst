How to Detect First Boot After Burning Program to Flash
########################################################

:date: 2018/10/12 22:00:00
:tags: Arduino, Embedded
:authors: Artium Nihamkin

.. role:: c(code)
   :language: c

I will write about Arduino, but this technique is relevant for any embedded
situation.

Many applications require retaining data such settings or parameters
between resets.
On the Arduino, the already existing EEPROM of the Atmega chip is a common
solution for this problem.

For the Arduino, the `EEPROM <https://www.arduino.cc/en/Reference/EEPROM>`_ library can be used to write or read values from the
EEPROM.

It is important that the program does not read from the EEPROM on the first
time it is run after it was burned. The reason is that the version that was
burned, might have different representation of the data than the one stored in
the EEPROM. This will cause "not so nice" problems that might not go away even
after resetting.

To solve this, one need to know when a program is run the first time after
it was burned, and use default values instead of reading from the EEPROM (and
of course store these to the EEPROM for next time)

This is sometimes called IPL (*Initial Program Load*) which means the first
time program is loaded into the RAM.

To detect IPL one can use a constant that changes every time a new
version of your program is produced. This constant is compared with a value
stored in the EEPROM, and if they are different, it means that a new program
was burned and this is it's first boot after burning. After this, the value is
stored in the EEPROM and subsequent boots will not be detected as IPL.

This constant can be managed manually, can be some preprocessor macro
representing git commit hash or date and time macro.

For the Arduino example below, I used date and time macros which I find simple
and robust:

.. code-block:: c

    /**
     * Address of the version data. This should never change between versions.
     */
    #define EEPROM_ADDR_VERSION_DATE 0x0

    /**
     * Your data should start after this location.
     * On gcc, __DATE_ is 11 chars long, __TIME__ is 8
     */
    #define EEPROM_ADD_START_OF_DATA 0x13

    /**
    * Determine if this is the first power-up after
    * fresh program was loaded into the flash.
    */
    boolean is_initial_program_load()
    {
        const String version_date = __DATE__ __TIME__;
        uint16_t len = version_date.length();
        boolean is_ipl = false;

        for (unsigned int i = 0; i < len; i++) {
            int addr = EEPROM_ADDR_VERSION_DATE + i;

            if (EEPROM.read(addr) != version_date[i]) {
                EEPROM.write(addr, version_date[i]);
                is_ipl = true;
            }
        }

        return is_ipl;
    }
