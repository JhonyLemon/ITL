classdef ConfigurationChange < uint8
    % Configuration change
    % Configuration change bit shall be set to a 1 to indicate that the PMU configuration will change.
    % Transition of bit 10 from 0 to 1 indicates that a configuration change will become effective in 1 min. This
    % bit is to be reset to 0 after 1 min and the configuration change shall be effective beginning with the first
    % message where bit 10 is 0. The bit serves as an indication that the receiving device should request the
    % configuration file to be sure configuration data is up to date. To be certain of having a valid configuration
    % file, the receiving device shall request a configuration file whenever it has been off-line for more than a
    % minute.
   enumeration
      ConfigurationWillCHange (1)   %upcoming configuration change
      ConfigurationWontCHange (0)   %no upcoming configuration change
   end
end


