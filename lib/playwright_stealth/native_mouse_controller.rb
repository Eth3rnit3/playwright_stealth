# frozen_string_literal: true

require 'ffi'
module FFI
  module X11
    extend FFI::Library
    ffi_lib 'libX11.so'
    ffi_lib 'libXtst.so'

    # Fonction pour ouvrir une connexion avec le serveur X
    attach_function :XOpenDisplay, [:string], :pointer
    attach_function :XCloseDisplay, [:pointer], :int

    # Fonction pour obtenir la fenêtre racine par défaut
    attach_function :XDefaultRootWindow, [:pointer], :ulong

    # Fonction pour définir l'input focus
    attach_function :XSetInputFocus, %i[pointer ulong int int], :int

    # Fonction pour déplacer la souris
    attach_function :XTestFakeMotionEvent, %i[pointer int int int ulong], :int

    # Fonction pour simuler un événement de clic
    attach_function :XTestFakeButtonEvent, %i[pointer uint bool ulong], :int

    # Fonction pour obtenir la position de la souris
    attach_function :XQueryPointer, %i[pointer ulong pointer pointer pointer pointer pointer pointer pointer], :bool

    # Fonction pour forcer l'envoi des événements X
    attach_function :XFlush, [:pointer], :int
  end
end

module PlaywrightStealth
  class NativeMouseController
    X_MIN = 10
    Y_MIN = 100
    X_MAX = 1920
    Y_MAX = 1080

    def initialize
      @display = FFI::X11.XOpenDisplay(nil)
      raise 'Cannot open display' if @display.null?
    end

    def set_focus
      root_window = FFI::X11.XDefaultRootWindow(@display)
      FFI::X11.XSetInputFocus(@display, root_window, 1, 0)
      FFI::X11.XFlush(@display)
    end

    def get_mouse_position
      root_window = FFI::X11.XDefaultRootWindow(@display)
      root_return = FFI::MemoryPointer.new(:ulong)
      child_return = FFI::MemoryPointer.new(:ulong)
      root_x = FFI::MemoryPointer.new(:int)
      root_y = FFI::MemoryPointer.new(:int)
      win_x = FFI::MemoryPointer.new(:int)
      win_y = FFI::MemoryPointer.new(:int)
      mask_return = FFI::MemoryPointer.new(:uint)

      FFI::X11.XQueryPointer(
        @display, root_window, root_return, child_return,
        root_x, root_y, win_x, win_y, mask_return
      )

      { x: root_x.read_int, y: root_y.read_int }
    end

    def move_mouse(target_x, target_y, steps = 50)
      current_pos = get_mouse_position
      delta_x = (target_x - current_pos[:x]).to_f / steps
      delta_y = (target_y - current_pos[:y]).to_f / steps

      steps.times do |i|
        new_x = current_pos[:x] + (delta_x * (i + 1)).round
        new_y = current_pos[:y] + (delta_y * (i + 1)).round

        FFI::X11.XTestFakeMotionEvent(@display, 0, new_x, new_y, 0)
        FFI::X11.XFlush(@display)
        sleep(0.01) # Ajout d'un léger délai pour simuler un mouvement naturel
      end
    end

    def click(button = 1)
      FFI::X11.XTestFakeButtonEvent(@display, button, true, 0)
      FFI::X11.XFlush(@display)
      sleep(0.05)
      FFI::X11.XTestFakeButtonEvent(@display, button, false, 0)
      FFI::X11.XFlush(@display)
    end

    def move_and_click(bounding_box)
      el_x = bounding_box['x'].to_i
      el_y = bounding_box['y'].to_i
      el_width = bounding_box['width'].to_i
      el_height = bounding_box['height'].to_i

      target_x = el_x + X_MIN + (el_width / 2)
      target_y = el_y + Y_MIN + (el_height / 2)

      move_mouse(target_x, target_y)
      click
    end

    def close
      FFI::X11.XCloseDisplay(@display)
    end
  end
end
