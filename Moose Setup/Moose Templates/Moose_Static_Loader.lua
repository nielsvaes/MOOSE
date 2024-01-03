
-- Automatic dynamic loading of development files, if they exists.
-- Try to load Moose as individual script files from <DcsInstallDir\Script\Moose
-- which should be a Junction link to the MOOSE repository subfolder "Moose Development\Moose".
-- This method is used by Moose developers and not mission builders.
ModuleLoader = 'Scripts/Moose/Modules.lua'

local f=io.open(ModuleLoader,"r")
if f~=nil then
  io.close(f)

  env.info( '*** MOOSE DYNAMIC INCLUDE START *** ' )

  local base = _G

  __Moose = {}

  __Moose.Include = function( IncludeFile )
    if not __Moose.Includes[ IncludeFile ] then
      __Moose.Includes[IncludeFile] = IncludeFile
      local f = assert( base.loadfile( IncludeFile ) )
      if f == nil then
        error ("Moose: Could not load Moose file " .. IncludeFile )
      else
        env.info( "Moose: " .. IncludeFile .. " dynamically loaded." )
        return f()
      end
    end
  end

  __Moose.Includes = {}

  __Moose.Include( 'Scripts/Moose/Modules.lua' )
  BASE:TraceOnOff( true )
  env.info( '*** MOOSE INCLUDE END *** ' )

  -- Skip the static part of this file completly
  do return end
end

-- Individual Moose files are not found. Use the static code below.
env.info( '*** MOOSE STATIC INCLUDE START *** ' )

