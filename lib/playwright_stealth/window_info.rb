# frozen_string_literal: true

require 'ffi'
module X11
  extend FFI::Library
  ffi_lib 'libX11'

  # Attache la fonction pour obtenir les attributs de la fenêtre
  attach_function :XOpenDisplay, [:string], :pointer
  attach_function :XRootWindow, %i[pointer int], :ulong
  attach_function :XGetGeometry, %i[pointer ulong pointer pointer pointer pointer pointer pointer pointer], :int
end

module PlaywrightStealth
  class WindowInfo
    def initialize
      @display = X11.XOpenDisplay(nil)
      raise 'Cannot open display' if @display.null?
    end

    def root_window
      X11.XRootWindow(@display, 0)
    end

    def window_geometry(window)
      root_return = FFI::MemoryPointer.new(:ulong)
      x_return = FFI::MemoryPointer.new(:int)
      y_return = FFI::MemoryPointer.new(:int)
      width_return = FFI::MemoryPointer.new(:uint)
      height_return = FFI::MemoryPointer.new(:uint)
      border_width_return = FFI::MemoryPointer.new(:uint)
      depth_return = FFI::MemoryPointer.new(:uint)

      success = X11.XGetGeometry(
        @display, window,
        root_return, x_return, y_return,
        width_return, height_return,
        border_width_return, depth_return
      )

      raise 'Failed to get window geometry' if success.zero?

      {
        x: x_return.read_int,
        y: y_return.read_int,
        width: width_return.read_uint,
        height: height_return.read_uint
      }
    end
  end
end
