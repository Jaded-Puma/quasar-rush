--- A library for rapid game development in lua.
-- The library is build for TIC80 but there's also a port to LOVE2D

lazy = {}

-- metadata
lazy.meta = {
	_NAME    = "lazylib-tic",
	_VERSION = "1.0",
	_AUTHOR  = "Esteban RPM (Jaded Puma)",
	_URL     = "jadedpuma.com",
	_LICENSE = "MIT"
}

-- setup
lazy.log = trace

-- load dependencies
require("lazylib-tic.base.class_base")
require("lazylib-tic.base.class_extend")
require("lazylib-tic.base.debug")
require("lazylib-tic.base.enum")
require("lazylib-tic.base.math")
require("lazylib-tic.base.math_vector")
require("lazylib-tic.base.util")
require("lazylib-tic.base.util_array2d")
require("lazylib-tic.base.tween")


-- states
require("lazylib-tic.base.state")
require("lazylib-tic.base.state_manager")
require("lazylib-tic.base.state_stack")
require("lazylib-tic.base.state_transition")

-- entity
require("lazylib-tic.base.entity")
require("lazylib-tic.base.entity_handler")
require("lazylib-tic.base.bounding_box")

-- late dependencies
require("lazylib-tic.base.particle_base")

-- tic
require("lazylib-tic.mod_animate")
require("lazylib-tic.tic-util")
require("lazylib-tic.animation_single_data")
require("lazylib-tic.animation_single")
--require("lazlib-tic.animation_data")
--require("lazlib-tic.animation")
--require("lazlib-tic.animation_renderer")
require("lazylib-tic.sfx_data")
require("lazylib-tic.base.camera")
require("lazylib-tic.transition_base")
require("lazylib-tic.transition_slide")

-- successful load
lazy.log("Loaded "..lazy.meta._NAME.." "..lazy.meta._VERSION)
