/**
 * Dlang vulkan platform specific types and functions as mixin template
 *
 * Copyright: Copyright 2015-2016 The Khronos Group Inc.; Copyright 2016 Alex Parrill, Peter Particle.
 * License:   $(https://opensource.org/licenses/MIT, MIT License).
 * Authors: Copyright 2016 Alex Parrill, Peter Particle
 */
module erupted.platform_extensions;

/// define platform extension names as enums
/// these enums can be used directly in Platform_Extensions mixin template
enum KHR_xlib_surface;
enum KHR_xcb_surface;
enum KHR_wayland_surface;
enum KHR_android_surface;
enum KHR_win32_surface;
enum KHR_video_queue;
enum KHR_video_decode_queue;
enum KHR_external_memory_win32;
enum KHR_win32_keyed_mutex;
enum KHR_external_semaphore_win32;
enum KHR_external_fence_win32;
enum KHR_portability_subset;
enum KHR_video_encode_queue;
enum EXT_video_encode_h264;
enum EXT_video_decode_h264;
enum GGP_stream_descriptor_surface;
enum NV_external_memory_win32;
enum NV_win32_keyed_mutex;
enum NN_vi_surface;
enum EXT_acquire_xlib_display;
enum MVK_ios_surface;
enum MVK_macos_surface;
enum ANDROID_external_memory_android_hardware_buffer;
enum EXT_video_decode_h265;
enum GGP_frame_token;
enum FUCHSIA_imagepipe_surface;
enum EXT_metal_surface;
enum EXT_full_screen_exclusive;
enum NV_acquire_winrt_display;
enum EXT_directfb_surface;
enum FUCHSIA_external_memory;
enum FUCHSIA_external_semaphore;
enum QNX_screen_surface;


/// extensions to a specific platform are grouped in these enum sequences
import std.meta : AliasSeq;
alias USE_PLATFORM_XLIB_KHR        = AliasSeq!( KHR_xlib_surface );
alias USE_PLATFORM_XCB_KHR         = AliasSeq!( KHR_xcb_surface );
alias USE_PLATFORM_WAYLAND_KHR     = AliasSeq!( KHR_wayland_surface );
alias USE_PLATFORM_ANDROID_KHR     = AliasSeq!( KHR_android_surface, ANDROID_external_memory_android_hardware_buffer );
alias USE_PLATFORM_WIN32_KHR       = AliasSeq!( KHR_win32_surface, KHR_external_memory_win32, KHR_win32_keyed_mutex, KHR_external_semaphore_win32, KHR_external_fence_win32, NV_external_memory_win32, NV_win32_keyed_mutex, EXT_full_screen_exclusive, NV_acquire_winrt_display );
alias ENABLE_BETA_EXTENSIONS       = AliasSeq!( KHR_video_queue, KHR_video_decode_queue, KHR_portability_subset, KHR_video_encode_queue, EXT_video_encode_h264, EXT_video_decode_h264, EXT_video_decode_h265 );
alias USE_PLATFORM_GGP             = AliasSeq!( GGP_stream_descriptor_surface, GGP_frame_token );
alias USE_PLATFORM_VI_NN           = AliasSeq!( NN_vi_surface );
alias USE_PLATFORM_XLIB_XRANDR_EXT = AliasSeq!( EXT_acquire_xlib_display );
alias USE_PLATFORM_IOS_MVK         = AliasSeq!( MVK_ios_surface );
alias USE_PLATFORM_MACOS_MVK       = AliasSeq!( MVK_macos_surface );
alias USE_PLATFORM_FUCHSIA         = AliasSeq!( FUCHSIA_imagepipe_surface, FUCHSIA_external_memory, FUCHSIA_external_semaphore );
alias USE_PLATFORM_METAL_EXT       = AliasSeq!( EXT_metal_surface );
alias USE_PLATFORM_DIRECTFB_EXT    = AliasSeq!( EXT_directfb_surface );
alias USE_PLATFORM_SCREEN_QNX      = AliasSeq!( QNX_screen_surface );



/// instantiate platform and extension specific code with this mixin template
/// required types and data structures must be imported into the module where
/// this template is instantiated
mixin template Platform_Extensions( extensions... ) {

    // publicly import erupted package modules
    public import erupted.types;
    public import erupted.functions;
    import erupted.dispatch_device;

    // mixin function linkage, nothrow and @nogc attributes for subsecuent functions
    extern(System) nothrow @nogc:

    // remove duplicates from alias sequence
    // this might happen if a platform extension collection AND a single extension, which is included in the collection, was specified
    // e.g.: mixin Platform_Extensions!( VK_USE_PLATFORM_WIN32_KHR, VK_KHR_external_memory_win32 );
    import std.meta : NoDuplicates;
    alias noDuplicateExtensions = NoDuplicates!extensions;

    // 1. loop through alias sequence and mixin corresponding
    // extension types, aliased function pointer type definitions and __gshared function pointer declarations
    static foreach( extension; noDuplicateExtensions ) {

        // VK_KHR_xlib_surface : types and function pointer type aliases
        static if( __traits( isSame, extension, KHR_xlib_surface )) {
            enum VK_KHR_xlib_surface = 1;

            enum VK_KHR_XLIB_SURFACE_SPEC_VERSION = 6;
            enum VK_KHR_XLIB_SURFACE_EXTENSION_NAME = "VK_KHR_xlib_surface";
            
            alias VkXlibSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkXlibSurfaceCreateInfoKHR {
                VkStructureType              sType = VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR;
                const( void )*               pNext;
                VkXlibSurfaceCreateFlagsKHR  flags;
                Display*                     dpy;
                Window                       window;
            }
            
            alias PFN_vkCreateXlibSurfaceKHR                                            = VkResult  function( VkInstance instance, const( VkXlibSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, Display* dpy, VisualID visualID );
        }

        // VK_KHR_xcb_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_xcb_surface )) {
            enum VK_KHR_xcb_surface = 1;

            enum VK_KHR_XCB_SURFACE_SPEC_VERSION = 6;
            enum VK_KHR_XCB_SURFACE_EXTENSION_NAME = "VK_KHR_xcb_surface";
            
            alias VkXcbSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkXcbSurfaceCreateInfoKHR {
                VkStructureType             sType = VK_STRUCTURE_TYPE_XCB_SURFACE_CREATE_INFO_KHR;
                const( void )*              pNext;
                VkXcbSurfaceCreateFlagsKHR  flags;
                xcb_connection_t*           connection;
                xcb_window_t                window;
            }
            
            alias PFN_vkCreateXcbSurfaceKHR                                             = VkResult  function( VkInstance instance, const( VkXcbSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, xcb_connection_t* connection, xcb_visualid_t visual_id );
        }

        // VK_KHR_wayland_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_wayland_surface )) {
            enum VK_KHR_wayland_surface = 1;

            enum VK_KHR_WAYLAND_SURFACE_SPEC_VERSION = 6;
            enum VK_KHR_WAYLAND_SURFACE_EXTENSION_NAME = "VK_KHR_wayland_surface";
            
            alias VkWaylandSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkWaylandSurfaceCreateInfoKHR {
                VkStructureType                 sType = VK_STRUCTURE_TYPE_WAYLAND_SURFACE_CREATE_INFO_KHR;
                const( void )*                  pNext;
                VkWaylandSurfaceCreateFlagsKHR  flags;
                const( wl_display )*            display;
                const( wl_surface )*            surface;
            }
            
            alias PFN_vkCreateWaylandSurfaceKHR                                         = VkResult  function( VkInstance instance, const( VkWaylandSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, const( wl_display )* display );
        }

        // VK_KHR_android_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_android_surface )) {
            enum VK_KHR_android_surface = 1;

            enum VK_KHR_ANDROID_SURFACE_SPEC_VERSION = 6;
            enum VK_KHR_ANDROID_SURFACE_EXTENSION_NAME = "VK_KHR_android_surface";
            
            alias VkAndroidSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkAndroidSurfaceCreateInfoKHR {
                VkStructureType                 sType = VK_STRUCTURE_TYPE_ANDROID_SURFACE_CREATE_INFO_KHR;
                const( void )*                  pNext;
                VkAndroidSurfaceCreateFlagsKHR  flags;
                const( ANativeWindow )*         window;
            }
            
            alias PFN_vkCreateAndroidSurfaceKHR                                         = VkResult  function( VkInstance instance, const( VkAndroidSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_KHR_win32_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_win32_surface )) {
            enum VK_KHR_win32_surface = 1;

            enum VK_KHR_WIN32_SURFACE_SPEC_VERSION = 6;
            enum VK_KHR_WIN32_SURFACE_EXTENSION_NAME = "VK_KHR_win32_surface";
            
            alias VkWin32SurfaceCreateFlagsKHR = VkFlags;
            
            struct VkWin32SurfaceCreateInfoKHR {
                VkStructureType               sType = VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR;
                const( void )*                pNext;
                VkWin32SurfaceCreateFlagsKHR  flags;
                HINSTANCE                     hinstance;
                HWND                          hwnd;
            }
            
            alias PFN_vkCreateWin32SurfaceKHR                                           = VkResult  function( VkInstance instance, const( VkWin32SurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex );
        }

        // VK_KHR_video_queue : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_video_queue )) {
            enum VK_KHR_video_queue = 1;

            mixin( VK_DEFINE_NON_DISPATCHABLE_HANDLE!q{VkVideoSessionKHR} );
            mixin( VK_DEFINE_NON_DISPATCHABLE_HANDLE!q{VkVideoSessionParametersKHR} );
            
            enum VK_KHR_VIDEO_QUEUE_SPEC_VERSION = 1;
            enum VK_KHR_VIDEO_QUEUE_EXTENSION_NAME = "VK_KHR_video_queue";
            
            enum VkQueryResultStatusKHR {
                VK_QUERY_RESULT_STATUS_ERROR_KHR             = -1,
                VK_QUERY_RESULT_STATUS_NOT_READY_KHR         = 0,
                VK_QUERY_RESULT_STATUS_COMPLETE_KHR          = 1,
                VK_QUERY_RESULT_STATUS_BEGIN_RANGE_KHR       = VK_QUERY_RESULT_STATUS_ERROR_KHR,
                VK_QUERY_RESULT_STATUS_END_RANGE_KHR         = VK_QUERY_RESULT_STATUS_COMPLETE_KHR,
                VK_QUERY_RESULT_STATUS_RANGE_SIZE_KHR        = VK_QUERY_RESULT_STATUS_COMPLETE_KHR - VK_QUERY_RESULT_STATUS_ERROR_KHR + 1,
                VK_QUERY_RESULT_STATUS_MAX_ENUM_KHR          = 0x7FFFFFFF
            }
            
            enum VK_QUERY_RESULT_STATUS_ERROR_KHR            = VkQueryResultStatusKHR.VK_QUERY_RESULT_STATUS_ERROR_KHR;
            enum VK_QUERY_RESULT_STATUS_NOT_READY_KHR        = VkQueryResultStatusKHR.VK_QUERY_RESULT_STATUS_NOT_READY_KHR;
            enum VK_QUERY_RESULT_STATUS_COMPLETE_KHR         = VkQueryResultStatusKHR.VK_QUERY_RESULT_STATUS_COMPLETE_KHR;
            enum VK_QUERY_RESULT_STATUS_BEGIN_RANGE_KHR      = VkQueryResultStatusKHR.VK_QUERY_RESULT_STATUS_BEGIN_RANGE_KHR;
            enum VK_QUERY_RESULT_STATUS_END_RANGE_KHR        = VkQueryResultStatusKHR.VK_QUERY_RESULT_STATUS_END_RANGE_KHR;
            enum VK_QUERY_RESULT_STATUS_RANGE_SIZE_KHR       = VkQueryResultStatusKHR.VK_QUERY_RESULT_STATUS_RANGE_SIZE_KHR;
            enum VK_QUERY_RESULT_STATUS_MAX_ENUM_KHR         = VkQueryResultStatusKHR.VK_QUERY_RESULT_STATUS_MAX_ENUM_KHR;
            
            alias VkVideoCodecOperationFlagsKHR = VkFlags;
            enum VkVideoCodecOperationFlagBitsKHR : VkVideoCodecOperationFlagsKHR {
                VK_VIDEO_CODEC_OPERATION_INVALID_BIT_KHR             = 0,
                VK_VIDEO_CODEC_OPERATION_ENCODE_H264_BIT_EXT         = 0x00010000,
                VK_VIDEO_CODEC_OPERATION_DECODE_H264_BIT_EXT         = 0x00000001,
                VK_VIDEO_CODEC_OPERATION_DECODE_H265_BIT_EXT         = 0x00000002,
                VK_VIDEO_CODEC_OPERATION_FLAG_BITS_MAX_ENUM_KHR      = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_CODEC_OPERATION_INVALID_BIT_KHR            = VkVideoCodecOperationFlagBitsKHR.VK_VIDEO_CODEC_OPERATION_INVALID_BIT_KHR;
            enum VK_VIDEO_CODEC_OPERATION_ENCODE_H264_BIT_EXT        = VkVideoCodecOperationFlagBitsKHR.VK_VIDEO_CODEC_OPERATION_ENCODE_H264_BIT_EXT;
            enum VK_VIDEO_CODEC_OPERATION_DECODE_H264_BIT_EXT        = VkVideoCodecOperationFlagBitsKHR.VK_VIDEO_CODEC_OPERATION_DECODE_H264_BIT_EXT;
            enum VK_VIDEO_CODEC_OPERATION_DECODE_H265_BIT_EXT        = VkVideoCodecOperationFlagBitsKHR.VK_VIDEO_CODEC_OPERATION_DECODE_H265_BIT_EXT;
            enum VK_VIDEO_CODEC_OPERATION_FLAG_BITS_MAX_ENUM_KHR     = VkVideoCodecOperationFlagBitsKHR.VK_VIDEO_CODEC_OPERATION_FLAG_BITS_MAX_ENUM_KHR;
            
            alias VkVideoChromaSubsamplingFlagsKHR = VkFlags;
            enum VkVideoChromaSubsamplingFlagBitsKHR : VkVideoChromaSubsamplingFlagsKHR {
                VK_VIDEO_CHROMA_SUBSAMPLING_INVALID_BIT_KHR          = 0,
                VK_VIDEO_CHROMA_SUBSAMPLING_MONOCHROME_BIT_KHR       = 0x00000001,
                VK_VIDEO_CHROMA_SUBSAMPLING_420_BIT_KHR              = 0x00000002,
                VK_VIDEO_CHROMA_SUBSAMPLING_422_BIT_KHR              = 0x00000004,
                VK_VIDEO_CHROMA_SUBSAMPLING_444_BIT_KHR              = 0x00000008,
                VK_VIDEO_CHROMA_SUBSAMPLING_FLAG_BITS_MAX_ENUM_KHR   = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_CHROMA_SUBSAMPLING_INVALID_BIT_KHR         = VkVideoChromaSubsamplingFlagBitsKHR.VK_VIDEO_CHROMA_SUBSAMPLING_INVALID_BIT_KHR;
            enum VK_VIDEO_CHROMA_SUBSAMPLING_MONOCHROME_BIT_KHR      = VkVideoChromaSubsamplingFlagBitsKHR.VK_VIDEO_CHROMA_SUBSAMPLING_MONOCHROME_BIT_KHR;
            enum VK_VIDEO_CHROMA_SUBSAMPLING_420_BIT_KHR             = VkVideoChromaSubsamplingFlagBitsKHR.VK_VIDEO_CHROMA_SUBSAMPLING_420_BIT_KHR;
            enum VK_VIDEO_CHROMA_SUBSAMPLING_422_BIT_KHR             = VkVideoChromaSubsamplingFlagBitsKHR.VK_VIDEO_CHROMA_SUBSAMPLING_422_BIT_KHR;
            enum VK_VIDEO_CHROMA_SUBSAMPLING_444_BIT_KHR             = VkVideoChromaSubsamplingFlagBitsKHR.VK_VIDEO_CHROMA_SUBSAMPLING_444_BIT_KHR;
            enum VK_VIDEO_CHROMA_SUBSAMPLING_FLAG_BITS_MAX_ENUM_KHR  = VkVideoChromaSubsamplingFlagBitsKHR.VK_VIDEO_CHROMA_SUBSAMPLING_FLAG_BITS_MAX_ENUM_KHR;
            
            alias VkVideoComponentBitDepthFlagsKHR = VkFlags;
            enum VkVideoComponentBitDepthFlagBitsKHR : VkVideoComponentBitDepthFlagsKHR {
                VK_VIDEO_COMPONENT_BIT_DEPTH_INVALID_KHR             = 0,
                VK_VIDEO_COMPONENT_BIT_DEPTH_8_BIT_KHR               = 0x00000001,
                VK_VIDEO_COMPONENT_BIT_DEPTH_10_BIT_KHR              = 0x00000004,
                VK_VIDEO_COMPONENT_BIT_DEPTH_12_BIT_KHR              = 0x00000010,
                VK_VIDEO_COMPONENT_BIT_DEPTH_FLAG_BITS_MAX_ENUM_KHR  = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_COMPONENT_BIT_DEPTH_INVALID_KHR            = VkVideoComponentBitDepthFlagBitsKHR.VK_VIDEO_COMPONENT_BIT_DEPTH_INVALID_KHR;
            enum VK_VIDEO_COMPONENT_BIT_DEPTH_8_BIT_KHR              = VkVideoComponentBitDepthFlagBitsKHR.VK_VIDEO_COMPONENT_BIT_DEPTH_8_BIT_KHR;
            enum VK_VIDEO_COMPONENT_BIT_DEPTH_10_BIT_KHR             = VkVideoComponentBitDepthFlagBitsKHR.VK_VIDEO_COMPONENT_BIT_DEPTH_10_BIT_KHR;
            enum VK_VIDEO_COMPONENT_BIT_DEPTH_12_BIT_KHR             = VkVideoComponentBitDepthFlagBitsKHR.VK_VIDEO_COMPONENT_BIT_DEPTH_12_BIT_KHR;
            enum VK_VIDEO_COMPONENT_BIT_DEPTH_FLAG_BITS_MAX_ENUM_KHR = VkVideoComponentBitDepthFlagBitsKHR.VK_VIDEO_COMPONENT_BIT_DEPTH_FLAG_BITS_MAX_ENUM_KHR;
            
            alias VkVideoCapabilitiesFlagsKHR = VkFlags;
            enum VkVideoCapabilitiesFlagBitsKHR : VkVideoCapabilitiesFlagsKHR {
                VK_VIDEO_CAPABILITIES_PROTECTED_CONTENT_BIT_KHR              = 0x00000001,
                VK_VIDEO_CAPABILITIES_SEPARATE_REFERENCE_IMAGES_BIT_KHR      = 0x00000002,
                VK_VIDEO_CAPABILITIES_FLAG_BITS_MAX_ENUM_KHR                 = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_CAPABILITIES_PROTECTED_CONTENT_BIT_KHR             = VkVideoCapabilitiesFlagBitsKHR.VK_VIDEO_CAPABILITIES_PROTECTED_CONTENT_BIT_KHR;
            enum VK_VIDEO_CAPABILITIES_SEPARATE_REFERENCE_IMAGES_BIT_KHR     = VkVideoCapabilitiesFlagBitsKHR.VK_VIDEO_CAPABILITIES_SEPARATE_REFERENCE_IMAGES_BIT_KHR;
            enum VK_VIDEO_CAPABILITIES_FLAG_BITS_MAX_ENUM_KHR                = VkVideoCapabilitiesFlagBitsKHR.VK_VIDEO_CAPABILITIES_FLAG_BITS_MAX_ENUM_KHR;
            
            alias VkVideoSessionCreateFlagsKHR = VkFlags;
            enum VkVideoSessionCreateFlagBitsKHR : VkVideoSessionCreateFlagsKHR {
                VK_VIDEO_SESSION_CREATE_DEFAULT_KHR                  = 0,
                VK_VIDEO_SESSION_CREATE_PROTECTED_CONTENT_BIT_KHR    = 0x00000001,
                VK_VIDEO_SESSION_CREATE_FLAG_BITS_MAX_ENUM_KHR       = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_SESSION_CREATE_DEFAULT_KHR                 = VkVideoSessionCreateFlagBitsKHR.VK_VIDEO_SESSION_CREATE_DEFAULT_KHR;
            enum VK_VIDEO_SESSION_CREATE_PROTECTED_CONTENT_BIT_KHR   = VkVideoSessionCreateFlagBitsKHR.VK_VIDEO_SESSION_CREATE_PROTECTED_CONTENT_BIT_KHR;
            enum VK_VIDEO_SESSION_CREATE_FLAG_BITS_MAX_ENUM_KHR      = VkVideoSessionCreateFlagBitsKHR.VK_VIDEO_SESSION_CREATE_FLAG_BITS_MAX_ENUM_KHR;
            alias VkVideoBeginCodingFlagsKHR = VkFlags;
            alias VkVideoEndCodingFlagsKHR = VkFlags;
            
            alias VkVideoCodingControlFlagsKHR = VkFlags;
            enum VkVideoCodingControlFlagBitsKHR : VkVideoCodingControlFlagsKHR {
                VK_VIDEO_CODING_CONTROL_DEFAULT_KHR                  = 0,
                VK_VIDEO_CODING_CONTROL_RESET_BIT_KHR                = 0x00000001,
                VK_VIDEO_CODING_CONTROL_FLAG_BITS_MAX_ENUM_KHR       = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_CODING_CONTROL_DEFAULT_KHR                 = VkVideoCodingControlFlagBitsKHR.VK_VIDEO_CODING_CONTROL_DEFAULT_KHR;
            enum VK_VIDEO_CODING_CONTROL_RESET_BIT_KHR               = VkVideoCodingControlFlagBitsKHR.VK_VIDEO_CODING_CONTROL_RESET_BIT_KHR;
            enum VK_VIDEO_CODING_CONTROL_FLAG_BITS_MAX_ENUM_KHR      = VkVideoCodingControlFlagBitsKHR.VK_VIDEO_CODING_CONTROL_FLAG_BITS_MAX_ENUM_KHR;
            
            alias VkVideoCodingQualityPresetFlagsKHR = VkFlags;
            enum VkVideoCodingQualityPresetFlagBitsKHR : VkVideoCodingQualityPresetFlagsKHR {
                VK_VIDEO_CODING_QUALITY_PRESET_DEFAULT_BIT_KHR               = 0,
                VK_VIDEO_CODING_QUALITY_PRESET_NORMAL_BIT_KHR                = 0x00000001,
                VK_VIDEO_CODING_QUALITY_PRESET_POWER_BIT_KHR                 = 0x00000002,
                VK_VIDEO_CODING_QUALITY_PRESET_QUALITY_BIT_KHR               = 0x00000004,
                VK_VIDEO_CODING_QUALITY_PRESET_FLAG_BITS_MAX_ENUM_KHR        = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_CODING_QUALITY_PRESET_DEFAULT_BIT_KHR              = VkVideoCodingQualityPresetFlagBitsKHR.VK_VIDEO_CODING_QUALITY_PRESET_DEFAULT_BIT_KHR;
            enum VK_VIDEO_CODING_QUALITY_PRESET_NORMAL_BIT_KHR               = VkVideoCodingQualityPresetFlagBitsKHR.VK_VIDEO_CODING_QUALITY_PRESET_NORMAL_BIT_KHR;
            enum VK_VIDEO_CODING_QUALITY_PRESET_POWER_BIT_KHR                = VkVideoCodingQualityPresetFlagBitsKHR.VK_VIDEO_CODING_QUALITY_PRESET_POWER_BIT_KHR;
            enum VK_VIDEO_CODING_QUALITY_PRESET_QUALITY_BIT_KHR              = VkVideoCodingQualityPresetFlagBitsKHR.VK_VIDEO_CODING_QUALITY_PRESET_QUALITY_BIT_KHR;
            enum VK_VIDEO_CODING_QUALITY_PRESET_FLAG_BITS_MAX_ENUM_KHR       = VkVideoCodingQualityPresetFlagBitsKHR.VK_VIDEO_CODING_QUALITY_PRESET_FLAG_BITS_MAX_ENUM_KHR;
            
            struct VkVideoQueueFamilyProperties2KHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_VIDEO_QUEUE_FAMILY_PROPERTIES_2_KHR;
                void*                          pNext;
                VkVideoCodecOperationFlagsKHR  videoCodecOperations;
            }
            
            struct VkVideoProfileKHR {
                VkStructureType                   sType = VK_STRUCTURE_TYPE_VIDEO_PROFILE_KHR;
                void*                             pNext;
                VkVideoCodecOperationFlagBitsKHR  videoCodecOperation;
                VkVideoChromaSubsamplingFlagsKHR  chromaSubsampling;
                VkVideoComponentBitDepthFlagsKHR  lumaBitDepth;
                VkVideoComponentBitDepthFlagsKHR  chromaBitDepth;
            }
            
            struct VkVideoProfilesKHR {
                VkStructureType              sType = VK_STRUCTURE_TYPE_VIDEO_PROFILES_KHR;
                void*                        pNext;
                uint32_t                     profileCount;
                const( VkVideoProfileKHR )*  pProfiles;
            }
            
            struct VkVideoCapabilitiesKHR {
                VkStructureType              sType = VK_STRUCTURE_TYPE_VIDEO_CAPABILITIES_KHR;
                void*                        pNext;
                VkVideoCapabilitiesFlagsKHR  capabilityFlags;
                VkDeviceSize                 minBitstreamBufferOffsetAlignment;
                VkDeviceSize                 minBitstreamBufferSizeAlignment;
                VkExtent2D                   videoPictureExtentGranularity;
                VkExtent2D                   minExtent;
                VkExtent2D                   maxExtent;
                uint32_t                     maxReferencePicturesSlotsCount;
                uint32_t                     maxReferencePicturesActiveCount;
            }
            
            struct VkPhysicalDeviceVideoFormatInfoKHR {
                VkStructureType               sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_FORMAT_INFO_KHR;
                void*                         pNext;
                VkImageUsageFlags             imageUsage;
                const( VkVideoProfilesKHR )*  pVideoProfiles;
            }
            
            struct VkVideoFormatPropertiesKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_VIDEO_FORMAT_PROPERTIES_KHR;
                void*            pNext;
                VkFormat         format;
            }
            
            struct VkVideoPictureResourceKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_VIDEO_PICTURE_RESOURCE_KHR;
                const( void )*   pNext;
                VkOffset2D       codedOffset;
                VkExtent2D       codedExtent;
                uint32_t         baseArrayLayer;
                VkImageView      imageViewBinding;
            }
            
            struct VkVideoReferenceSlotKHR {
                VkStructureType                      sType = VK_STRUCTURE_TYPE_VIDEO_REFERENCE_SLOT_KHR;
                const( void )*                       pNext;
                int8_t                               slotIndex;
                const( VkVideoPictureResourceKHR )*  pPictureResource;
            }
            
            struct VkVideoGetMemoryPropertiesKHR {
                VkStructureType         sType = VK_STRUCTURE_TYPE_VIDEO_GET_MEMORY_PROPERTIES_KHR;
                const( void )*          pNext;
                uint32_t                memoryBindIndex;
                VkMemoryRequirements2*  pMemoryRequirements;
            }
            
            struct VkVideoBindMemoryKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_VIDEO_BIND_MEMORY_KHR;
                const( void )*   pNext;
                uint32_t         memoryBindIndex;
                VkDeviceMemory   memory;
                VkDeviceSize     memoryOffset;
                VkDeviceSize     memorySize;
            }
            
            struct VkVideoSessionCreateInfoKHR {
                VkStructureType               sType = VK_STRUCTURE_TYPE_VIDEO_SESSION_CREATE_INFO_KHR;
                const( void )*                pNext;
                uint32_t                      queueFamilyIndex;
                VkVideoSessionCreateFlagsKHR  flags;
                const( VkVideoProfileKHR )*   pVideoProfile;
                VkFormat                      pictureFormat;
                VkExtent2D                    maxCodedExtent;
                VkFormat                      referencePicturesFormat;
                uint32_t                      maxReferencePicturesSlotsCount;
                uint32_t                      maxReferencePicturesActiveCount;
            }
            
            struct VkVideoSessionParametersCreateInfoKHR {
                VkStructureType              sType = VK_STRUCTURE_TYPE_VIDEO_SESSION_PARAMETERS_CREATE_INFO_KHR;
                const( void )*               pNext;
                VkVideoSessionParametersKHR  videoSessionParametersTemplate;
                VkVideoSessionKHR            videoSession;
            }
            
            struct VkVideoSessionParametersUpdateInfoKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_VIDEO_SESSION_PARAMETERS_UPDATE_INFO_KHR;
                const( void )*   pNext;
                uint32_t         updateSequenceCount;
            }
            
            struct VkVideoBeginCodingInfoKHR {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_VIDEO_BEGIN_CODING_INFO_KHR;
                const( void )*                      pNext;
                VkVideoBeginCodingFlagsKHR          flags;
                VkVideoCodingQualityPresetFlagsKHR  codecQualityPreset;
                VkVideoSessionKHR                   videoSession;
                VkVideoSessionParametersKHR         videoSessionParameters;
                uint32_t                            referenceSlotCount;
                const( VkVideoReferenceSlotKHR )*   pReferenceSlots;
            }
            
            struct VkVideoEndCodingInfoKHR {
                VkStructureType           sType = VK_STRUCTURE_TYPE_VIDEO_END_CODING_INFO_KHR;
                const( void )*            pNext;
                VkVideoEndCodingFlagsKHR  flags;
            }
            
            struct VkVideoCodingControlInfoKHR {
                VkStructureType               sType = VK_STRUCTURE_TYPE_VIDEO_CODING_CONTROL_INFO_KHR;
                const( void )*                pNext;
                VkVideoCodingControlFlagsKHR  flags;
            }
            
            alias PFN_vkGetPhysicalDeviceVideoCapabilitiesKHR                           = VkResult  function( VkPhysicalDevice physicalDevice, const( VkVideoProfileKHR )* pVideoProfile, VkVideoCapabilitiesKHR* pCapabilities );
            alias PFN_vkGetPhysicalDeviceVideoFormatPropertiesKHR                       = VkResult  function( VkPhysicalDevice physicalDevice, const( VkPhysicalDeviceVideoFormatInfoKHR )* pVideoFormatInfo, uint32_t* pVideoFormatPropertyCount, VkVideoFormatPropertiesKHR* pVideoFormatProperties );
            alias PFN_vkCreateVideoSessionKHR                                           = VkResult  function( VkDevice device, const( VkVideoSessionCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkVideoSessionKHR* pVideoSession );
            alias PFN_vkDestroyVideoSessionKHR                                          = void      function( VkDevice device, VkVideoSessionKHR videoSession, const( VkAllocationCallbacks )* pAllocator );
            alias PFN_vkGetVideoSessionMemoryRequirementsKHR                            = VkResult  function( VkDevice device, VkVideoSessionKHR videoSession, uint32_t* pVideoSessionMemoryRequirementsCount, VkVideoGetMemoryPropertiesKHR* pVideoSessionMemoryRequirements );
            alias PFN_vkBindVideoSessionMemoryKHR                                       = VkResult  function( VkDevice device, VkVideoSessionKHR videoSession, uint32_t videoSessionBindMemoryCount, const( VkVideoBindMemoryKHR )* pVideoSessionBindMemories );
            alias PFN_vkCreateVideoSessionParametersKHR                                 = VkResult  function( VkDevice device, const( VkVideoSessionParametersCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkVideoSessionParametersKHR* pVideoSessionParameters );
            alias PFN_vkUpdateVideoSessionParametersKHR                                 = VkResult  function( VkDevice device, VkVideoSessionParametersKHR videoSessionParameters, const( VkVideoSessionParametersUpdateInfoKHR )* pUpdateInfo );
            alias PFN_vkDestroyVideoSessionParametersKHR                                = void      function( VkDevice device, VkVideoSessionParametersKHR videoSessionParameters, const( VkAllocationCallbacks )* pAllocator );
            alias PFN_vkCmdBeginVideoCodingKHR                                          = void      function( VkCommandBuffer commandBuffer, const( VkVideoBeginCodingInfoKHR )* pBeginInfo );
            alias PFN_vkCmdEndVideoCodingKHR                                            = void      function( VkCommandBuffer commandBuffer, const( VkVideoEndCodingInfoKHR )* pEndCodingInfo );
            alias PFN_vkCmdControlVideoCodingKHR                                        = void      function( VkCommandBuffer commandBuffer, const( VkVideoCodingControlInfoKHR )* pCodingControlInfo );
        }

        // VK_KHR_video_decode_queue : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_video_decode_queue )) {
            enum VK_KHR_video_decode_queue = 1;

            enum VK_KHR_VIDEO_DECODE_QUEUE_SPEC_VERSION = 1;
            enum VK_KHR_VIDEO_DECODE_QUEUE_EXTENSION_NAME = "VK_KHR_video_decode_queue";
            
            alias VkVideoDecodeFlagsKHR = VkFlags;
            enum VkVideoDecodeFlagBitsKHR : VkVideoDecodeFlagsKHR {
                VK_VIDEO_DECODE_DEFAULT_KHR                  = 0,
                VK_VIDEO_DECODE_RESERVED_0_BIT_KHR           = 0x00000001,
                VK_VIDEO_DECODE_FLAG_BITS_MAX_ENUM_KHR       = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_DECODE_DEFAULT_KHR                 = VkVideoDecodeFlagBitsKHR.VK_VIDEO_DECODE_DEFAULT_KHR;
            enum VK_VIDEO_DECODE_RESERVED_0_BIT_KHR          = VkVideoDecodeFlagBitsKHR.VK_VIDEO_DECODE_RESERVED_0_BIT_KHR;
            enum VK_VIDEO_DECODE_FLAG_BITS_MAX_ENUM_KHR      = VkVideoDecodeFlagBitsKHR.VK_VIDEO_DECODE_FLAG_BITS_MAX_ENUM_KHR;
            
            struct VkVideoDecodeInfoKHR {
                VkStructureType                    sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_INFO_KHR;
                const( void )*                     pNext;
                VkVideoDecodeFlagsKHR              flags;
                VkOffset2D                         codedOffset;
                VkExtent2D                         codedExtent;
                VkBuffer                           srcBuffer;
                VkDeviceSize                       srcBufferOffset;
                VkDeviceSize                       srcBufferRange;
                VkVideoPictureResourceKHR          dstPictureResource;
                const( VkVideoReferenceSlotKHR )*  pSetupReferenceSlot;
                uint32_t                           referenceSlotCount;
                const( VkVideoReferenceSlotKHR )*  pReferenceSlots;
            }
            
            alias PFN_vkCmdDecodeVideoKHR                                               = void      function( VkCommandBuffer commandBuffer, const( VkVideoDecodeInfoKHR )* pFrameInfo );
        }

        // VK_KHR_external_memory_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
            enum VK_KHR_external_memory_win32 = 1;

            enum VK_KHR_EXTERNAL_MEMORY_WIN32_SPEC_VERSION = 1;
            enum VK_KHR_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME = "VK_KHR_external_memory_win32";
            
            struct VkImportMemoryWin32HandleInfoKHR {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
                const( void )*                      pNext;
                VkExternalMemoryHandleTypeFlagBits  handleType;
                HANDLE                              handle;
                LPCWSTR                             name;
            }
            
            struct VkExportMemoryWin32HandleInfoKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
                LPCWSTR                        name;
            }
            
            struct VkMemoryWin32HandlePropertiesKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_MEMORY_WIN32_HANDLE_PROPERTIES_KHR;
                void*            pNext;
                uint32_t         memoryTypeBits;
            }
            
            struct VkMemoryGetWin32HandleInfoKHR {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR;
                const( void )*                      pNext;
                VkDeviceMemory                      memory;
                VkExternalMemoryHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkGetMemoryWin32HandleKHR                                         = VkResult  function( VkDevice device, const( VkMemoryGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle );
            alias PFN_vkGetMemoryWin32HandlePropertiesKHR                               = VkResult  function( VkDevice device, VkExternalMemoryHandleTypeFlagBits handleType, HANDLE handle, VkMemoryWin32HandlePropertiesKHR* pMemoryWin32HandleProperties );
        }

        // VK_KHR_win32_keyed_mutex : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_win32_keyed_mutex )) {
            enum VK_KHR_win32_keyed_mutex = 1;

            enum VK_KHR_WIN32_KEYED_MUTEX_SPEC_VERSION = 1;
            enum VK_KHR_WIN32_KEYED_MUTEX_EXTENSION_NAME = "VK_KHR_win32_keyed_mutex";
            
            struct VkWin32KeyedMutexAcquireReleaseInfoKHR {
                VkStructureType           sType = VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_KHR;
                const( void )*            pNext;
                uint32_t                  acquireCount;
                const( VkDeviceMemory )*  pAcquireSyncs;
                const( uint64_t )*        pAcquireKeys;
                const( uint32_t )*        pAcquireTimeouts;
                uint32_t                  releaseCount;
                const( VkDeviceMemory )*  pReleaseSyncs;
                const( uint64_t )*        pReleaseKeys;
            }
            
        }

        // VK_KHR_external_semaphore_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
            enum VK_KHR_external_semaphore_win32 = 1;

            enum VK_KHR_EXTERNAL_SEMAPHORE_WIN32_SPEC_VERSION = 1;
            enum VK_KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME = "VK_KHR_external_semaphore_win32";
            
            struct VkImportSemaphoreWin32HandleInfoKHR {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
                const( void )*                         pNext;
                VkSemaphore                            semaphore;
                VkSemaphoreImportFlags                 flags;
                VkExternalSemaphoreHandleTypeFlagBits  handleType;
                HANDLE                                 handle;
                LPCWSTR                                name;
            }
            
            struct VkExportSemaphoreWin32HandleInfoKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
                LPCWSTR                        name;
            }
            
            struct VkD3D12FenceSubmitInfoKHR {
                VkStructureType     sType = VK_STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR;
                const( void )*      pNext;
                uint32_t            waitSemaphoreValuesCount;
                const( uint64_t )*  pWaitSemaphoreValues;
                uint32_t            signalSemaphoreValuesCount;
                const( uint64_t )*  pSignalSemaphoreValues;
            }
            
            struct VkSemaphoreGetWin32HandleInfoKHR {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR;
                const( void )*                         pNext;
                VkSemaphore                            semaphore;
                VkExternalSemaphoreHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkImportSemaphoreWin32HandleKHR                                   = VkResult  function( VkDevice device, const( VkImportSemaphoreWin32HandleInfoKHR )* pImportSemaphoreWin32HandleInfo );
            alias PFN_vkGetSemaphoreWin32HandleKHR                                      = VkResult  function( VkDevice device, const( VkSemaphoreGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle );
        }

        // VK_KHR_external_fence_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
            enum VK_KHR_external_fence_win32 = 1;

            enum VK_KHR_EXTERNAL_FENCE_WIN32_SPEC_VERSION = 1;
            enum VK_KHR_EXTERNAL_FENCE_WIN32_EXTENSION_NAME = "VK_KHR_external_fence_win32";
            
            struct VkImportFenceWin32HandleInfoKHR {
                VkStructureType                    sType = VK_STRUCTURE_TYPE_IMPORT_FENCE_WIN32_HANDLE_INFO_KHR;
                const( void )*                     pNext;
                VkFence                            fence;
                VkFenceImportFlags                 flags;
                VkExternalFenceHandleTypeFlagBits  handleType;
                HANDLE                             handle;
                LPCWSTR                            name;
            }
            
            struct VkExportFenceWin32HandleInfoKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_FENCE_WIN32_HANDLE_INFO_KHR;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
                LPCWSTR                        name;
            }
            
            struct VkFenceGetWin32HandleInfoKHR {
                VkStructureType                    sType = VK_STRUCTURE_TYPE_FENCE_GET_WIN32_HANDLE_INFO_KHR;
                const( void )*                     pNext;
                VkFence                            fence;
                VkExternalFenceHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkImportFenceWin32HandleKHR                                       = VkResult  function( VkDevice device, const( VkImportFenceWin32HandleInfoKHR )* pImportFenceWin32HandleInfo );
            alias PFN_vkGetFenceWin32HandleKHR                                          = VkResult  function( VkDevice device, const( VkFenceGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle );
        }

        // VK_KHR_portability_subset : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_portability_subset )) {
            enum VK_KHR_portability_subset = 1;

            enum VK_KHR_PORTABILITY_SUBSET_SPEC_VERSION = 1;
            enum VK_KHR_PORTABILITY_SUBSET_EXTENSION_NAME = "VK_KHR_portability_subset";
            
            struct VkPhysicalDevicePortabilitySubsetFeaturesKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PORTABILITY_SUBSET_FEATURES_KHR;
                void*            pNext;
                VkBool32         constantAlphaColorBlendFactors;
                VkBool32         events;
                VkBool32         imageViewFormatReinterpretation;
                VkBool32         imageViewFormatSwizzle;
                VkBool32         imageView2DOn3DImage;
                VkBool32         multisampleArrayImage;
                VkBool32         mutableComparisonSamplers;
                VkBool32         pointPolygons;
                VkBool32         samplerMipLodBias;
                VkBool32         separateStencilMaskRef;
                VkBool32         shaderSampleRateInterpolationFunctions;
                VkBool32         tessellationIsolines;
                VkBool32         tessellationPointMode;
                VkBool32         triangleFans;
                VkBool32         vertexAttributeAccessBeyondStride;
            }
            
            struct VkPhysicalDevicePortabilitySubsetPropertiesKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PORTABILITY_SUBSET_PROPERTIES_KHR;
                void*            pNext;
                uint32_t         minVertexInputBindingStrideAlignment;
            }
            
        }

        // VK_KHR_video_encode_queue : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
            enum VK_KHR_video_encode_queue = 1;

            enum VK_KHR_VIDEO_ENCODE_QUEUE_SPEC_VERSION = 2;
            enum VK_KHR_VIDEO_ENCODE_QUEUE_EXTENSION_NAME = "VK_KHR_video_encode_queue";
            
            alias VkVideoEncodeFlagsKHR = VkFlags;
            enum VkVideoEncodeFlagBitsKHR : VkVideoEncodeFlagsKHR {
                VK_VIDEO_ENCODE_DEFAULT_KHR                  = 0,
                VK_VIDEO_ENCODE_RESERVED_0_BIT_KHR           = 0x00000001,
                VK_VIDEO_ENCODE_FLAG_BITS_MAX_ENUM_KHR       = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_DEFAULT_KHR                 = VkVideoEncodeFlagBitsKHR.VK_VIDEO_ENCODE_DEFAULT_KHR;
            enum VK_VIDEO_ENCODE_RESERVED_0_BIT_KHR          = VkVideoEncodeFlagBitsKHR.VK_VIDEO_ENCODE_RESERVED_0_BIT_KHR;
            enum VK_VIDEO_ENCODE_FLAG_BITS_MAX_ENUM_KHR      = VkVideoEncodeFlagBitsKHR.VK_VIDEO_ENCODE_FLAG_BITS_MAX_ENUM_KHR;
            
            alias VkVideoEncodeRateControlFlagsKHR = VkFlags;
            enum VkVideoEncodeRateControlFlagBitsKHR : VkVideoEncodeRateControlFlagsKHR {
                VK_VIDEO_ENCODE_RATE_CONTROL_DEFAULT_KHR             = 0,
                VK_VIDEO_ENCODE_RATE_CONTROL_RESET_BIT_KHR           = 0x00000001,
                VK_VIDEO_ENCODE_RATE_CONTROL_FLAG_BITS_MAX_ENUM_KHR  = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_RATE_CONTROL_DEFAULT_KHR            = VkVideoEncodeRateControlFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_DEFAULT_KHR;
            enum VK_VIDEO_ENCODE_RATE_CONTROL_RESET_BIT_KHR          = VkVideoEncodeRateControlFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_RESET_BIT_KHR;
            enum VK_VIDEO_ENCODE_RATE_CONTROL_FLAG_BITS_MAX_ENUM_KHR = VkVideoEncodeRateControlFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_FLAG_BITS_MAX_ENUM_KHR;
            
            alias VkVideoEncodeRateControlModeFlagsKHR = VkFlags;
            enum VkVideoEncodeRateControlModeFlagBitsKHR : VkVideoEncodeRateControlModeFlagsKHR {
                VK_VIDEO_ENCODE_RATE_CONTROL_MODE_NONE_BIT_KHR               = 0,
                VK_VIDEO_ENCODE_RATE_CONTROL_MODE_CBR_BIT_KHR                = 1,
                VK_VIDEO_ENCODE_RATE_CONTROL_MODE_VBR_BIT_KHR                = 2,
                VK_VIDEO_ENCODE_RATE_CONTROL_MODE_FLAG_BITS_MAX_ENUM_KHR     = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_RATE_CONTROL_MODE_NONE_BIT_KHR              = VkVideoEncodeRateControlModeFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_MODE_NONE_BIT_KHR;
            enum VK_VIDEO_ENCODE_RATE_CONTROL_MODE_CBR_BIT_KHR               = VkVideoEncodeRateControlModeFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_MODE_CBR_BIT_KHR;
            enum VK_VIDEO_ENCODE_RATE_CONTROL_MODE_VBR_BIT_KHR               = VkVideoEncodeRateControlModeFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_MODE_VBR_BIT_KHR;
            enum VK_VIDEO_ENCODE_RATE_CONTROL_MODE_FLAG_BITS_MAX_ENUM_KHR    = VkVideoEncodeRateControlModeFlagBitsKHR.VK_VIDEO_ENCODE_RATE_CONTROL_MODE_FLAG_BITS_MAX_ENUM_KHR;
            
            struct VkVideoEncodeInfoKHR {
                VkStructureType                    sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_INFO_KHR;
                const( void )*                     pNext;
                VkVideoEncodeFlagsKHR              flags;
                uint32_t                           qualityLevel;
                VkExtent2D                         codedExtent;
                VkBuffer                           dstBitstreamBuffer;
                VkDeviceSize                       dstBitstreamBufferOffset;
                VkDeviceSize                       dstBitstreamBufferMaxRange;
                VkVideoPictureResourceKHR          srcPictureResource;
                const( VkVideoReferenceSlotKHR )*  pSetupReferenceSlot;
                uint32_t                           referenceSlotCount;
                const( VkVideoReferenceSlotKHR )*  pReferenceSlots;
            }
            
            struct VkVideoEncodeRateControlInfoKHR {
                VkStructureType                          sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_RATE_CONTROL_INFO_KHR;
                const( void )*                           pNext;
                VkVideoEncodeRateControlFlagsKHR         flags;
                VkVideoEncodeRateControlModeFlagBitsKHR  rateControlMode;
                uint32_t                                 averageBitrate;
                uint16_t                                 peakToAverageBitrateRatio;
                uint16_t                                 frameRateNumerator;
                uint16_t                                 frameRateDenominator;
                uint32_t                                 virtualBufferSizeInMs;
            }
            
            alias PFN_vkCmdEncodeVideoKHR                                               = void      function( VkCommandBuffer commandBuffer, const( VkVideoEncodeInfoKHR )* pEncodeInfo );
        }

        // VK_EXT_video_encode_h264 : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_video_encode_h264 )) {
            enum VK_EXT_video_encode_h264 = 1;

            enum VK_EXT_VIDEO_ENCODE_H264_SPEC_VERSION = 1;
            enum VK_EXT_VIDEO_ENCODE_H264_EXTENSION_NAME = "VK_EXT_video_encode_h264";
            
            alias VkVideoEncodeH264CapabilitiesFlagsEXT = VkFlags;
            enum VkVideoEncodeH264CapabilitiesFlagBitsEXT : VkVideoEncodeH264CapabilitiesFlagsEXT {
                VK_VIDEO_ENCODE_H264_CAPABILITY_CABAC_BIT_EXT                                = 0x00000001,
                VK_VIDEO_ENCODE_H264_CAPABILITY_CAVLC_BIT_EXT                                = 0x00000002,
                VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_BI_PRED_IMPLICIT_BIT_EXT            = 0x00000004,
                VK_VIDEO_ENCODE_H264_CAPABILITY_TRANSFORM_8X8_BIT_EXT                        = 0x00000008,
                VK_VIDEO_ENCODE_H264_CAPABILITY_CHROMA_QP_OFFSET_BIT_EXT                     = 0x00000010,
                VK_VIDEO_ENCODE_H264_CAPABILITY_SECOND_CHROMA_QP_OFFSET_BIT_EXT              = 0x00000020,
                VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_DISABLED_BIT_EXT           = 0x00000040,
                VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_ENABLED_BIT_EXT            = 0x00000080,
                VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_PARTIAL_BIT_EXT            = 0x00000100,
                VK_VIDEO_ENCODE_H264_CAPABILITY_MULTIPLE_SLICE_PER_FRAME_BIT_EXT             = 0x00000200,
                VK_VIDEO_ENCODE_H264_CAPABILITY_EVENLY_DISTRIBUTED_SLICE_SIZE_BIT_EXT        = 0x00000400,
                VK_VIDEO_ENCODE_H2_64_CAPABILITIES_FLAG_BITS_MAX_ENUM_EXT                    = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_CABAC_BIT_EXT                               = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_CABAC_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_CAVLC_BIT_EXT                               = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_CAVLC_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_BI_PRED_IMPLICIT_BIT_EXT           = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_WEIGHTED_BI_PRED_IMPLICIT_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_TRANSFORM_8X8_BIT_EXT                       = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_TRANSFORM_8X8_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_CHROMA_QP_OFFSET_BIT_EXT                    = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_CHROMA_QP_OFFSET_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_SECOND_CHROMA_QP_OFFSET_BIT_EXT             = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_SECOND_CHROMA_QP_OFFSET_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_DISABLED_BIT_EXT          = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_DISABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_ENABLED_BIT_EXT           = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_ENABLED_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_PARTIAL_BIT_EXT           = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_DEBLOCKING_FILTER_PARTIAL_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_MULTIPLE_SLICE_PER_FRAME_BIT_EXT            = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_MULTIPLE_SLICE_PER_FRAME_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_CAPABILITY_EVENLY_DISTRIBUTED_SLICE_SIZE_BIT_EXT       = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H264_CAPABILITY_EVENLY_DISTRIBUTED_SLICE_SIZE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H2_64_CAPABILITIES_FLAG_BITS_MAX_ENUM_EXT                   = VkVideoEncodeH264CapabilitiesFlagBitsEXT.VK_VIDEO_ENCODE_H2_64_CAPABILITIES_FLAG_BITS_MAX_ENUM_EXT;
            
            alias VkVideoEncodeH264InputModeFlagsEXT = VkFlags;
            enum VkVideoEncodeH264InputModeFlagBitsEXT : VkVideoEncodeH264InputModeFlagsEXT {
                VK_VIDEO_ENCODE_H264_INPUT_MODE_FRAME_BIT_EXT                = 0x00000001,
                VK_VIDEO_ENCODE_H264_INPUT_MODE_SLICE_BIT_EXT                = 0x00000002,
                VK_VIDEO_ENCODE_H264_INPUT_MODE_NON_VCL_BIT_EXT              = 0x00000004,
                VK_VIDEO_ENCODE_H2_64_INPUT_MODE_FLAG_BITS_MAX_ENUM_EXT      = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_H264_INPUT_MODE_FRAME_BIT_EXT               = VkVideoEncodeH264InputModeFlagBitsEXT.VK_VIDEO_ENCODE_H264_INPUT_MODE_FRAME_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_INPUT_MODE_SLICE_BIT_EXT               = VkVideoEncodeH264InputModeFlagBitsEXT.VK_VIDEO_ENCODE_H264_INPUT_MODE_SLICE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_INPUT_MODE_NON_VCL_BIT_EXT             = VkVideoEncodeH264InputModeFlagBitsEXT.VK_VIDEO_ENCODE_H264_INPUT_MODE_NON_VCL_BIT_EXT;
            enum VK_VIDEO_ENCODE_H2_64_INPUT_MODE_FLAG_BITS_MAX_ENUM_EXT     = VkVideoEncodeH264InputModeFlagBitsEXT.VK_VIDEO_ENCODE_H2_64_INPUT_MODE_FLAG_BITS_MAX_ENUM_EXT;
            
            alias VkVideoEncodeH264OutputModeFlagsEXT = VkFlags;
            enum VkVideoEncodeH264OutputModeFlagBitsEXT : VkVideoEncodeH264OutputModeFlagsEXT {
                VK_VIDEO_ENCODE_H264_OUTPUT_MODE_FRAME_BIT_EXT               = 0x00000001,
                VK_VIDEO_ENCODE_H264_OUTPUT_MODE_SLICE_BIT_EXT               = 0x00000002,
                VK_VIDEO_ENCODE_H264_OUTPUT_MODE_NON_VCL_BIT_EXT             = 0x00000004,
                VK_VIDEO_ENCODE_H2_64_OUTPUT_MODE_FLAG_BITS_MAX_ENUM_EXT     = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_H264_OUTPUT_MODE_FRAME_BIT_EXT              = VkVideoEncodeH264OutputModeFlagBitsEXT.VK_VIDEO_ENCODE_H264_OUTPUT_MODE_FRAME_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_OUTPUT_MODE_SLICE_BIT_EXT              = VkVideoEncodeH264OutputModeFlagBitsEXT.VK_VIDEO_ENCODE_H264_OUTPUT_MODE_SLICE_BIT_EXT;
            enum VK_VIDEO_ENCODE_H264_OUTPUT_MODE_NON_VCL_BIT_EXT            = VkVideoEncodeH264OutputModeFlagBitsEXT.VK_VIDEO_ENCODE_H264_OUTPUT_MODE_NON_VCL_BIT_EXT;
            enum VK_VIDEO_ENCODE_H2_64_OUTPUT_MODE_FLAG_BITS_MAX_ENUM_EXT    = VkVideoEncodeH264OutputModeFlagBitsEXT.VK_VIDEO_ENCODE_H2_64_OUTPUT_MODE_FLAG_BITS_MAX_ENUM_EXT;
            
            alias VkVideoEncodeH264CreateFlagsEXT = VkFlags;
            enum VkVideoEncodeH264CreateFlagBitsEXT : VkVideoEncodeH264CreateFlagsEXT {
                VK_VIDEO_ENCODE_H264_CREATE_DEFAULT_EXT              = 0,
                VK_VIDEO_ENCODE_H264_CREATE_RESERVED_0_BIT_EXT       = 0x00000001,
                VK_VIDEO_ENCODE_H2_64_CREATE_FLAG_BITS_MAX_ENUM_EXT  = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_ENCODE_H264_CREATE_DEFAULT_EXT             = VkVideoEncodeH264CreateFlagBitsEXT.VK_VIDEO_ENCODE_H264_CREATE_DEFAULT_EXT;
            enum VK_VIDEO_ENCODE_H264_CREATE_RESERVED_0_BIT_EXT      = VkVideoEncodeH264CreateFlagBitsEXT.VK_VIDEO_ENCODE_H264_CREATE_RESERVED_0_BIT_EXT;
            enum VK_VIDEO_ENCODE_H2_64_CREATE_FLAG_BITS_MAX_ENUM_EXT = VkVideoEncodeH264CreateFlagBitsEXT.VK_VIDEO_ENCODE_H2_64_CREATE_FLAG_BITS_MAX_ENUM_EXT;
            
            struct VkVideoEncodeH264CapabilitiesEXT {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_CAPABILITIES_EXT;
                const( void )*                         pNext;
                VkVideoEncodeH264CapabilitiesFlagsEXT  flags;
                VkVideoEncodeH264InputModeFlagsEXT     inputModeFlags;
                VkVideoEncodeH264OutputModeFlagsEXT    outputModeFlags;
                VkExtent2D                             minPictureSizeInMbs;
                VkExtent2D                             maxPictureSizeInMbs;
                VkExtent2D                             inputImageDataAlignment;
                uint8_t                                maxNumL0ReferenceForP;
                uint8_t                                maxNumL0ReferenceForB;
                uint8_t                                maxNumL1Reference;
                uint8_t                                qualityLevelCount;
                VkExtensionProperties                  stdExtensionVersion;
            }
            
            struct VkVideoEncodeH264SessionCreateInfoEXT {
                VkStructureType                  sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_SESSION_CREATE_INFO_EXT;
                const( void )*                   pNext;
                VkVideoEncodeH264CreateFlagsEXT  flags;
                VkExtent2D                       maxPictureSizeInMbs;
                const( VkExtensionProperties )*  pStdExtensionVersion;
            }
            
            struct VkVideoEncodeH264SessionParametersAddInfoEXT {
                VkStructureType                             sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_SESSION_PARAMETERS_ADD_INFO_EXT;
                const( void )*                              pNext;
                uint32_t                                    spsStdCount;
                const( StdVideoH264SequenceParameterSet )*  pSpsStd;
                uint32_t                                    ppsStdCount;
                const( StdVideoH264PictureParameterSet )*   pPpsStd;
            }
            
            struct VkVideoEncodeH264SessionParametersCreateInfoEXT {
                VkStructureType                                         sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_SESSION_PARAMETERS_CREATE_INFO_EXT;
                const( void )*                                          pNext;
                uint32_t                                                maxSpsStdCount;
                uint32_t                                                maxPpsStdCount;
                const( VkVideoEncodeH264SessionParametersAddInfoEXT )*  pParametersAddInfo;
            }
            
            struct VkVideoEncodeH264DpbSlotInfoEXT {
                VkStructureType                          sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_DPB_SLOT_INFO_EXT;
                const( void )*                           pNext;
                int8_t                                   slotIndex;
                const( StdVideoEncodeH264PictureInfo )*  pStdPictureInfo;
            }
            
            struct VkVideoEncodeH264NaluSliceEXT {
                VkStructureType                            sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_NALU_SLICE_EXT;
                const( void )*                             pNext;
                const( StdVideoEncodeH264SliceHeader )*    pSliceHeaderStd;
                uint32_t                                   mbCount;
                uint8_t                                    refFinalList0EntryCount;
                const( VkVideoEncodeH264DpbSlotInfoEXT )*  pRefFinalList0Entries;
                uint8_t                                    refFinalList1EntryCount;
                const( VkVideoEncodeH264DpbSlotInfoEXT )*  pRefFinalList1Entries;
                uint32_t                                   precedingNaluBytes;
                uint8_t                                    minQp;
                uint8_t                                    maxQp;
            }
            
            struct VkVideoEncodeH264VclFrameInfoEXT {
                VkStructureType                            sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_VCL_FRAME_INFO_EXT;
                const( void )*                             pNext;
                uint8_t                                    refDefaultFinalList0EntryCount;
                const( VkVideoEncodeH264DpbSlotInfoEXT )*  pRefDefaultFinalList0Entries;
                uint8_t                                    refDefaultFinalList1EntryCount;
                const( VkVideoEncodeH264DpbSlotInfoEXT )*  pRefDefaultFinalList1Entries;
                uint32_t                                   naluSliceEntryCount;
                const( VkVideoEncodeH264NaluSliceEXT )*    pNaluSliceEntries;
                const( VkVideoEncodeH264DpbSlotInfoEXT )*  pCurrentPictureInfo;
            }
            
            struct VkVideoEncodeH264EmitPictureParametersEXT {
                VkStructureType    sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_EMIT_PICTURE_PARAMETERS_EXT;
                const( void )*     pNext;
                uint8_t            spsId;
                VkBool32           emitSpsEnable;
                uint32_t           ppsIdEntryCount;
                const( uint8_t )*  ppsIdEntries;
            }
            
            struct VkVideoEncodeH264ProfileEXT {
                VkStructureType         sType = VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_PROFILE_EXT;
                const( void )*          pNext;
                StdVideoH264ProfileIdc  stdProfileIdc;
            }
            
        }

        // VK_EXT_video_decode_h264 : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_video_decode_h264 )) {
            enum VK_EXT_video_decode_h264 = 1;

            enum VK_EXT_VIDEO_DECODE_H264_SPEC_VERSION = 1;
            enum VK_EXT_VIDEO_DECODE_H264_EXTENSION_NAME = "VK_EXT_video_decode_h264";
            
            alias VkVideoDecodeH264FieldLayoutFlagsEXT = VkFlags;
            enum VkVideoDecodeH264FieldLayoutFlagBitsEXT : VkVideoDecodeH264FieldLayoutFlagsEXT {
                VK_VIDEO_DECODE_H264_PROGRESSIVE_PICTURES_ONLY_EXT                   = 0,
                VK_VIDEO_DECODE_H264_FIELD_LAYOUT_LINE_INTERLACED_PLANE_BIT_EXT      = 0x00000001,
                VK_VIDEO_DECODE_H264_FIELD_LAYOUT_SEPARATE_INTERLACED_PLANE_BIT_EXT  = 0x00000002,
                VK_VIDEO_DECODE_H2_64_FIELD_LAYOUT_FLAG_BITS_MAX_ENUM_EXT            = 0x7FFFFFFF
            }
            
            enum VK_VIDEO_DECODE_H264_PROGRESSIVE_PICTURES_ONLY_EXT                  = VkVideoDecodeH264FieldLayoutFlagBitsEXT.VK_VIDEO_DECODE_H264_PROGRESSIVE_PICTURES_ONLY_EXT;
            enum VK_VIDEO_DECODE_H264_FIELD_LAYOUT_LINE_INTERLACED_PLANE_BIT_EXT     = VkVideoDecodeH264FieldLayoutFlagBitsEXT.VK_VIDEO_DECODE_H264_FIELD_LAYOUT_LINE_INTERLACED_PLANE_BIT_EXT;
            enum VK_VIDEO_DECODE_H264_FIELD_LAYOUT_SEPARATE_INTERLACED_PLANE_BIT_EXT = VkVideoDecodeH264FieldLayoutFlagBitsEXT.VK_VIDEO_DECODE_H264_FIELD_LAYOUT_SEPARATE_INTERLACED_PLANE_BIT_EXT;
            enum VK_VIDEO_DECODE_H2_64_FIELD_LAYOUT_FLAG_BITS_MAX_ENUM_EXT           = VkVideoDecodeH264FieldLayoutFlagBitsEXT.VK_VIDEO_DECODE_H2_64_FIELD_LAYOUT_FLAG_BITS_MAX_ENUM_EXT;
            alias VkVideoDecodeH264CreateFlagsEXT = VkFlags;
            
            struct VkVideoDecodeH264ProfileEXT {
                VkStructureType                       sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_PROFILE_EXT;
                const( void )*                        pNext;
                StdVideoH264ProfileIdc                stdProfileIdc;
                VkVideoDecodeH264FieldLayoutFlagsEXT  fieldLayout;
            }
            
            struct VkVideoDecodeH264CapabilitiesEXT {
                VkStructureType        sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_CAPABILITIES_EXT;
                void*                  pNext;
                uint32_t               maxLevel;
                VkOffset2D             fieldOffsetGranularity;
                VkExtensionProperties  stdExtensionVersion;
            }
            
            struct VkVideoDecodeH264SessionCreateInfoEXT {
                VkStructureType                  sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_SESSION_CREATE_INFO_EXT;
                const( void )*                   pNext;
                VkVideoDecodeH264CreateFlagsEXT  flags;
                const( VkExtensionProperties )*  pStdExtensionVersion;
            }
            
            struct VkVideoDecodeH264SessionParametersAddInfoEXT {
                VkStructureType                             sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_SESSION_PARAMETERS_ADD_INFO_EXT;
                const( void )*                              pNext;
                uint32_t                                    spsStdCount;
                const( StdVideoH264SequenceParameterSet )*  pSpsStd;
                uint32_t                                    ppsStdCount;
                const( StdVideoH264PictureParameterSet )*   pPpsStd;
            }
            
            struct VkVideoDecodeH264SessionParametersCreateInfoEXT {
                VkStructureType                                         sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_SESSION_PARAMETERS_CREATE_INFO_EXT;
                const( void )*                                          pNext;
                uint32_t                                                maxSpsStdCount;
                uint32_t                                                maxPpsStdCount;
                const( VkVideoDecodeH264SessionParametersAddInfoEXT )*  pParametersAddInfo;
            }
            
            struct VkVideoDecodeH264PictureInfoEXT {
                VkStructureType                          sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_PICTURE_INFO_EXT;
                const( void )*                           pNext;
                const( StdVideoDecodeH264PictureInfo )*  pStdPictureInfo;
                uint32_t                                 slicesCount;
                const( uint32_t )*                       pSlicesDataOffsets;
            }
            
            struct VkVideoDecodeH264MvcEXT {
                VkStructureType                  sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_MVC_EXT;
                const( void )*                   pNext;
                const( StdVideoDecodeH264Mvc )*  pStdMvc;
            }
            
            struct VkVideoDecodeH264DpbSlotInfoEXT {
                VkStructureType                            sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_DPB_SLOT_INFO_EXT;
                const( void )*                             pNext;
                const( StdVideoDecodeH264ReferenceInfo )*  pStdReferenceInfo;
            }
            
        }

        // VK_GGP_stream_descriptor_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
            enum VK_GGP_stream_descriptor_surface = 1;

            enum VK_GGP_STREAM_DESCRIPTOR_SURFACE_SPEC_VERSION = 1;
            enum VK_GGP_STREAM_DESCRIPTOR_SURFACE_EXTENSION_NAME = "VK_GGP_stream_descriptor_surface";
            
            alias VkStreamDescriptorSurfaceCreateFlagsGGP = VkFlags;
            
            struct VkStreamDescriptorSurfaceCreateInfoGGP {
                VkStructureType                          sType = VK_STRUCTURE_TYPE_STREAM_DESCRIPTOR_SURFACE_CREATE_INFO_GGP;
                const( void )*                           pNext;
                VkStreamDescriptorSurfaceCreateFlagsGGP  flags;
                GgpStreamDescriptor                      streamDescriptor;
            }
            
            alias PFN_vkCreateStreamDescriptorSurfaceGGP                                = VkResult  function( VkInstance instance, const( VkStreamDescriptorSurfaceCreateInfoGGP )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_NV_external_memory_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
            enum VK_NV_external_memory_win32 = 1;

            enum VK_NV_EXTERNAL_MEMORY_WIN32_SPEC_VERSION = 1;
            enum VK_NV_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME = "VK_NV_external_memory_win32";
            
            struct VkImportMemoryWin32HandleInfoNV {
                VkStructureType                    sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_NV;
                const( void )*                     pNext;
                VkExternalMemoryHandleTypeFlagsNV  handleType;
                HANDLE                             handle;
            }
            
            struct VkExportMemoryWin32HandleInfoNV {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_NV;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
            }
            
            alias PFN_vkGetMemoryWin32HandleNV                                          = VkResult  function( VkDevice device, VkDeviceMemory memory, VkExternalMemoryHandleTypeFlagsNV handleType, HANDLE* pHandle );
        }

        // VK_NV_win32_keyed_mutex : types and function pointer type aliases
        else static if( __traits( isSame, extension, NV_win32_keyed_mutex )) {
            enum VK_NV_win32_keyed_mutex = 1;

            enum VK_NV_WIN32_KEYED_MUTEX_SPEC_VERSION = 2;
            enum VK_NV_WIN32_KEYED_MUTEX_EXTENSION_NAME = "VK_NV_win32_keyed_mutex";
            
            struct VkWin32KeyedMutexAcquireReleaseInfoNV {
                VkStructureType           sType = VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_NV;
                const( void )*            pNext;
                uint32_t                  acquireCount;
                const( VkDeviceMemory )*  pAcquireSyncs;
                const( uint64_t )*        pAcquireKeys;
                const( uint32_t )*        pAcquireTimeoutMilliseconds;
                uint32_t                  releaseCount;
                const( VkDeviceMemory )*  pReleaseSyncs;
                const( uint64_t )*        pReleaseKeys;
            }
            
        }

        // VK_NN_vi_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, NN_vi_surface )) {
            enum VK_NN_vi_surface = 1;

            enum VK_NN_VI_SURFACE_SPEC_VERSION = 1;
            enum VK_NN_VI_SURFACE_EXTENSION_NAME = "VK_NN_vi_surface";
            
            alias VkViSurfaceCreateFlagsNN = VkFlags;
            
            struct VkViSurfaceCreateInfoNN {
                VkStructureType           sType = VK_STRUCTURE_TYPE_VI_SURFACE_CREATE_INFO_NN;
                const( void )*            pNext;
                VkViSurfaceCreateFlagsNN  flags;
                void*                     window;
            }
            
            alias PFN_vkCreateViSurfaceNN                                               = VkResult  function( VkInstance instance, const( VkViSurfaceCreateInfoNN )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_EXT_acquire_xlib_display : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
            enum VK_EXT_acquire_xlib_display = 1;

            enum VK_EXT_ACQUIRE_XLIB_DISPLAY_SPEC_VERSION = 1;
            enum VK_EXT_ACQUIRE_XLIB_DISPLAY_EXTENSION_NAME = "VK_EXT_acquire_xlib_display";
            
            alias PFN_vkAcquireXlibDisplayEXT                                           = VkResult  function( VkPhysicalDevice physicalDevice, Display* dpy, VkDisplayKHR display );
            alias PFN_vkGetRandROutputDisplayEXT                                        = VkResult  function( VkPhysicalDevice physicalDevice, Display* dpy, RROutput rrOutput, VkDisplayKHR* pDisplay );
        }

        // VK_MVK_ios_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, MVK_ios_surface )) {
            enum VK_MVK_ios_surface = 1;

            enum VK_MVK_IOS_SURFACE_SPEC_VERSION = 3;
            enum VK_MVK_IOS_SURFACE_EXTENSION_NAME = "VK_MVK_ios_surface";
            
            alias VkIOSSurfaceCreateFlagsMVK = VkFlags;
            
            struct VkIOSSurfaceCreateInfoMVK {
                VkStructureType             sType = VK_STRUCTURE_TYPE_IOS_SURFACE_CREATE_INFO_MVK;
                const( void )*              pNext;
                VkIOSSurfaceCreateFlagsMVK  flags;
                const( void )*              pView;
            }
            
            alias PFN_vkCreateIOSSurfaceMVK                                             = VkResult  function( VkInstance instance, const( VkIOSSurfaceCreateInfoMVK )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_MVK_macos_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, MVK_macos_surface )) {
            enum VK_MVK_macos_surface = 1;

            enum VK_MVK_MACOS_SURFACE_SPEC_VERSION = 3;
            enum VK_MVK_MACOS_SURFACE_EXTENSION_NAME = "VK_MVK_macos_surface";
            
            alias VkMacOSSurfaceCreateFlagsMVK = VkFlags;
            
            struct VkMacOSSurfaceCreateInfoMVK {
                VkStructureType               sType = VK_STRUCTURE_TYPE_MACOS_SURFACE_CREATE_INFO_MVK;
                const( void )*                pNext;
                VkMacOSSurfaceCreateFlagsMVK  flags;
                const( void )*                pView;
            }
            
            alias PFN_vkCreateMacOSSurfaceMVK                                           = VkResult  function( VkInstance instance, const( VkMacOSSurfaceCreateInfoMVK )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_ANDROID_external_memory_android_hardware_buffer : types and function pointer type aliases
        else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
            enum VK_ANDROID_external_memory_android_hardware_buffer = 1;

            enum VK_ANDROID_EXTERNAL_MEMORY_ANDROID_HARDWARE_BUFFER_SPEC_VERSION = 3;
            enum VK_ANDROID_EXTERNAL_MEMORY_ANDROID_HARDWARE_BUFFER_EXTENSION_NAME = "VK_ANDROID_external_memory_android_hardware_buffer";
            
            struct VkAndroidHardwareBufferUsageANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_USAGE_ANDROID;
                void*            pNext;
                uint64_t         androidHardwareBufferUsage;
            }
            
            struct VkAndroidHardwareBufferPropertiesANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_PROPERTIES_ANDROID;
                void*            pNext;
                VkDeviceSize     allocationSize;
                uint32_t         memoryTypeBits;
            }
            
            struct VkAndroidHardwareBufferFormatPropertiesANDROID {
                VkStructureType                sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_PROPERTIES_ANDROID;
                void*                          pNext;
                VkFormat                       format;
                uint64_t                       externalFormat;
                VkFormatFeatureFlags           formatFeatures;
                VkComponentMapping             samplerYcbcrConversionComponents;
                VkSamplerYcbcrModelConversion  suggestedYcbcrModel;
                VkSamplerYcbcrRange            suggestedYcbcrRange;
                VkChromaLocation               suggestedXChromaOffset;
                VkChromaLocation               suggestedYChromaOffset;
            }
            
            struct VkImportAndroidHardwareBufferInfoANDROID {
                VkStructureType            sType = VK_STRUCTURE_TYPE_IMPORT_ANDROID_HARDWARE_BUFFER_INFO_ANDROID;
                const( void )*             pNext;
                const( AHardwareBuffer )*  buffer;
            }
            
            struct VkMemoryGetAndroidHardwareBufferInfoANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_MEMORY_GET_ANDROID_HARDWARE_BUFFER_INFO_ANDROID;
                const( void )*   pNext;
                VkDeviceMemory   memory;
            }
            
            struct VkExternalFormatANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_EXTERNAL_FORMAT_ANDROID;
                void*            pNext;
                uint64_t         externalFormat;
            }
            
            alias PFN_vkGetAndroidHardwareBufferPropertiesANDROID                       = VkResult  function( VkDevice device, const( AHardwareBuffer )* buffer, VkAndroidHardwareBufferPropertiesANDROID* pProperties );
            alias PFN_vkGetMemoryAndroidHardwareBufferANDROID                           = VkResult  function( VkDevice device, const( VkMemoryGetAndroidHardwareBufferInfoANDROID )* pInfo, AHardwareBuffer pBuffer );
        }

        // VK_EXT_video_decode_h265 : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_video_decode_h265 )) {
            enum VK_EXT_video_decode_h265 = 1;

            enum VK_EXT_VIDEO_DECODE_H265_SPEC_VERSION = 1;
            enum VK_EXT_VIDEO_DECODE_H265_EXTENSION_NAME = "VK_EXT_video_decode_h265";
            
            alias VkVideoDecodeH265CreateFlagsEXT = VkFlags;
            
            struct VkVideoDecodeH265ProfileEXT {
                VkStructureType         sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_PROFILE_EXT;
                const( void )*          pNext;
                StdVideoH265ProfileIdc  stdProfileIdc;
            }
            
            struct VkVideoDecodeH265CapabilitiesEXT {
                VkStructureType        sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_CAPABILITIES_EXT;
                void*                  pNext;
                uint32_t               maxLevel;
                VkExtensionProperties  stdExtensionVersion;
            }
            
            struct VkVideoDecodeH265SessionCreateInfoEXT {
                VkStructureType                  sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_SESSION_CREATE_INFO_EXT;
                const( void )*                   pNext;
                VkVideoDecodeH265CreateFlagsEXT  flags;
                const( VkExtensionProperties )*  pStdExtensionVersion;
            }
            
            struct VkVideoDecodeH265SessionParametersAddInfoEXT {
                VkStructureType                             sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_SESSION_PARAMETERS_ADD_INFO_EXT;
                const( void )*                              pNext;
                uint32_t                                    spsStdCount;
                const( StdVideoH265SequenceParameterSet )*  pSpsStd;
                uint32_t                                    ppsStdCount;
                const( StdVideoH265PictureParameterSet )*   pPpsStd;
            }
            
            struct VkVideoDecodeH265SessionParametersCreateInfoEXT {
                VkStructureType                                         sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_SESSION_PARAMETERS_CREATE_INFO_EXT;
                const( void )*                                          pNext;
                uint32_t                                                maxSpsStdCount;
                uint32_t                                                maxPpsStdCount;
                const( VkVideoDecodeH265SessionParametersAddInfoEXT )*  pParametersAddInfo;
            }
            
            struct VkVideoDecodeH265PictureInfoEXT {
                VkStructureType                 sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_PICTURE_INFO_EXT;
                const( void )*                  pNext;
                StdVideoDecodeH265PictureInfo*  pStdPictureInfo;
                uint32_t                        slicesCount;
                const( uint32_t )*              pSlicesDataOffsets;
            }
            
            struct VkVideoDecodeH265DpbSlotInfoEXT {
                VkStructureType                            sType = VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_DPB_SLOT_INFO_EXT;
                const( void )*                             pNext;
                const( StdVideoDecodeH265ReferenceInfo )*  pStdReferenceInfo;
            }
            
        }

        // VK_GGP_frame_token : types and function pointer type aliases
        else static if( __traits( isSame, extension, GGP_frame_token )) {
            enum VK_GGP_frame_token = 1;

            enum VK_GGP_FRAME_TOKEN_SPEC_VERSION = 1;
            enum VK_GGP_FRAME_TOKEN_EXTENSION_NAME = "VK_GGP_frame_token";
            
            struct VkPresentFrameTokenGGP {
                VkStructureType  sType = VK_STRUCTURE_TYPE_PRESENT_FRAME_TOKEN_GGP;
                const( void )*   pNext;
                GgpFrameToken    frameToken;
            }
            
        }

        // VK_FUCHSIA_imagepipe_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
            enum VK_FUCHSIA_imagepipe_surface = 1;

            enum VK_FUCHSIA_IMAGEPIPE_SURFACE_SPEC_VERSION = 1;
            enum VK_FUCHSIA_IMAGEPIPE_SURFACE_EXTENSION_NAME = "VK_FUCHSIA_imagepipe_surface";
            
            alias VkImagePipeSurfaceCreateFlagsFUCHSIA = VkFlags;
            
            struct VkImagePipeSurfaceCreateInfoFUCHSIA {
                VkStructureType                       sType = VK_STRUCTURE_TYPE_IMAGEPIPE_SURFACE_CREATE_INFO_FUCHSIA;
                const( void )*                        pNext;
                VkImagePipeSurfaceCreateFlagsFUCHSIA  flags;
                zx_handle_t                           imagePipeHandle;
            }
            
            alias PFN_vkCreateImagePipeSurfaceFUCHSIA                                   = VkResult  function( VkInstance instance, const( VkImagePipeSurfaceCreateInfoFUCHSIA )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_EXT_metal_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_metal_surface )) {
            enum VK_EXT_metal_surface = 1;

            enum VK_EXT_METAL_SURFACE_SPEC_VERSION = 1;
            enum VK_EXT_METAL_SURFACE_EXTENSION_NAME = "VK_EXT_metal_surface";
            
            alias VkMetalSurfaceCreateFlagsEXT = VkFlags;
            
            struct VkMetalSurfaceCreateInfoEXT {
                VkStructureType               sType = VK_STRUCTURE_TYPE_METAL_SURFACE_CREATE_INFO_EXT;
                const( void )*                pNext;
                VkMetalSurfaceCreateFlagsEXT  flags;
                const( CAMetalLayer )*        pLayer;
            }
            
            alias PFN_vkCreateMetalSurfaceEXT                                           = VkResult  function( VkInstance instance, const( VkMetalSurfaceCreateInfoEXT )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_EXT_full_screen_exclusive : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
            enum VK_EXT_full_screen_exclusive = 1;

            enum VK_EXT_FULL_SCREEN_EXCLUSIVE_SPEC_VERSION = 4;
            enum VK_EXT_FULL_SCREEN_EXCLUSIVE_EXTENSION_NAME = "VK_EXT_full_screen_exclusive";
            
            enum VkFullScreenExclusiveEXT {
                VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT                 = 0,
                VK_FULL_SCREEN_EXCLUSIVE_ALLOWED_EXT                 = 1,
                VK_FULL_SCREEN_EXCLUSIVE_DISALLOWED_EXT              = 2,
                VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT  = 3,
                VK_FULL_SCREEN_EXCLUSIVE_BEGIN_RANGE_EXT             = VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT,
                VK_FULL_SCREEN_EXCLUSIVE_END_RANGE_EXT               = VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT,
                VK_FULL_SCREEN_EXCLUSIVE_RANGE_SIZE_EXT              = VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT - VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT + 1,
                VK_FULL_SCREEN_EXCLUSIVE_MAX_ENUM_EXT                = 0x7FFFFFFF
            }
            
            enum VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT                = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_ALLOWED_EXT                = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_ALLOWED_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_DISALLOWED_EXT             = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_DISALLOWED_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_BEGIN_RANGE_EXT            = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_BEGIN_RANGE_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_END_RANGE_EXT              = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_END_RANGE_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_RANGE_SIZE_EXT             = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_RANGE_SIZE_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_MAX_ENUM_EXT               = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_MAX_ENUM_EXT;
            
            struct VkSurfaceFullScreenExclusiveInfoEXT {
                VkStructureType           sType = VK_STRUCTURE_TYPE_SURFACE_FULL_SCREEN_EXCLUSIVE_INFO_EXT;
                void*                     pNext;
                VkFullScreenExclusiveEXT  fullScreenExclusive;
            }
            
            struct VkSurfaceCapabilitiesFullScreenExclusiveEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_FULL_SCREEN_EXCLUSIVE_EXT;
                void*            pNext;
                VkBool32         fullScreenExclusiveSupported;
            }
            
            struct VkSurfaceFullScreenExclusiveWin32InfoEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_SURFACE_FULL_SCREEN_EXCLUSIVE_WIN32_INFO_EXT;
                const( void )*   pNext;
                HMONITOR         hmonitor;
            }
            
            alias PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        = VkResult  function( VkPhysicalDevice physicalDevice, const( VkPhysicalDeviceSurfaceInfo2KHR )* pSurfaceInfo, uint32_t* pPresentModeCount, VkPresentModeKHR* pPresentModes );
            alias PFN_vkAcquireFullScreenExclusiveModeEXT                               = VkResult  function( VkDevice device, VkSwapchainKHR swapchain );
            alias PFN_vkReleaseFullScreenExclusiveModeEXT                               = VkResult  function( VkDevice device, VkSwapchainKHR swapchain );
            alias PFN_vkGetDeviceGroupSurfacePresentModes2EXT                           = VkResult  function( VkDevice device, const( VkPhysicalDeviceSurfaceInfo2KHR )* pSurfaceInfo, VkDeviceGroupPresentModeFlagsKHR* pModes );
        }

        // VK_NV_acquire_winrt_display : types and function pointer type aliases
        else static if( __traits( isSame, extension, NV_acquire_winrt_display )) {
            enum VK_NV_acquire_winrt_display = 1;

            enum VK_NV_ACQUIRE_WINRT_DISPLAY_SPEC_VERSION = 1;
            enum VK_NV_ACQUIRE_WINRT_DISPLAY_EXTENSION_NAME = "VK_NV_acquire_winrt_display";
            
            alias PFN_vkAcquireWinrtDisplayNV                                           = VkResult  function( VkPhysicalDevice physicalDevice, VkDisplayKHR display );
            alias PFN_vkGetWinrtDisplayNV                                               = VkResult  function( VkPhysicalDevice physicalDevice, uint32_t deviceRelativeId, VkDisplayKHR* pDisplay );
        }

        // VK_EXT_directfb_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_directfb_surface )) {
            enum VK_EXT_directfb_surface = 1;

            enum VK_EXT_DIRECTFB_SURFACE_SPEC_VERSION = 1;
            enum VK_EXT_DIRECTFB_SURFACE_EXTENSION_NAME = "VK_EXT_directfb_surface";
            
            alias VkDirectFBSurfaceCreateFlagsEXT = VkFlags;
            
            struct VkDirectFBSurfaceCreateInfoEXT {
                VkStructureType                  sType = VK_STRUCTURE_TYPE_DIRECTFB_SURFACE_CREATE_INFO_EXT;
                const( void )*                   pNext;
                VkDirectFBSurfaceCreateFlagsEXT  flags;
                IDirectFB*                       dfb;
                IDirectFBSurface*                surface;
            }
            
            alias PFN_vkCreateDirectFBSurfaceEXT                                        = VkResult  function( VkInstance instance, const( VkDirectFBSurfaceCreateInfoEXT )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, IDirectFB* dfb );
        }

        // VK_FUCHSIA_external_memory : types and function pointer type aliases
        else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
            enum VK_FUCHSIA_external_memory = 1;

            enum VK_FUCHSIA_EXTERNAL_MEMORY_SPEC_VERSION = 1;
            enum VK_FUCHSIA_EXTERNAL_MEMORY_EXTENSION_NAME = "VK_FUCHSIA_external_memory";
            
            struct VkImportMemoryZirconHandleInfoFUCHSIA {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_ZIRCON_HANDLE_INFO_FUCHSIA;
                const( void )*                      pNext;
                VkExternalMemoryHandleTypeFlagBits  handleType;
                zx_handle_t                         handle;
            }
            
            struct VkMemoryZirconHandlePropertiesFUCHSIA {
                VkStructureType  sType = VK_STRUCTURE_TYPE_MEMORY_ZIRCON_HANDLE_PROPERTIES_FUCHSIA;
                void*            pNext;
                uint32_t         memoryTypeBits;
            }
            
            struct VkMemoryGetZirconHandleInfoFUCHSIA {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_MEMORY_GET_ZIRCON_HANDLE_INFO_FUCHSIA;
                const( void )*                      pNext;
                VkDeviceMemory                      memory;
                VkExternalMemoryHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkGetMemoryZirconHandleFUCHSIA                                    = VkResult  function( VkDevice device, const( VkMemoryGetZirconHandleInfoFUCHSIA )* pGetZirconHandleInfo, zx_handle_t* pZirconHandle );
            alias PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA                          = VkResult  function( VkDevice device, VkExternalMemoryHandleTypeFlagBits handleType, zx_handle_t zirconHandle, VkMemoryZirconHandlePropertiesFUCHSIA* pMemoryZirconHandleProperties );
        }

        // VK_FUCHSIA_external_semaphore : types and function pointer type aliases
        else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
            enum VK_FUCHSIA_external_semaphore = 1;

            enum VK_FUCHSIA_EXTERNAL_SEMAPHORE_SPEC_VERSION = 1;
            enum VK_FUCHSIA_EXTERNAL_SEMAPHORE_EXTENSION_NAME = "VK_FUCHSIA_external_semaphore";
            
            struct VkImportSemaphoreZirconHandleInfoFUCHSIA {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_ZIRCON_HANDLE_INFO_FUCHSIA;
                const( void )*                         pNext;
                VkSemaphore                            semaphore;
                VkSemaphoreImportFlags                 flags;
                VkExternalSemaphoreHandleTypeFlagBits  handleType;
                zx_handle_t                            zirconHandle;
            }
            
            struct VkSemaphoreGetZirconHandleInfoFUCHSIA {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_SEMAPHORE_GET_ZIRCON_HANDLE_INFO_FUCHSIA;
                const( void )*                         pNext;
                VkSemaphore                            semaphore;
                VkExternalSemaphoreHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkImportSemaphoreZirconHandleFUCHSIA                              = VkResult  function( VkDevice device, const( VkImportSemaphoreZirconHandleInfoFUCHSIA )* pImportSemaphoreZirconHandleInfo );
            alias PFN_vkGetSemaphoreZirconHandleFUCHSIA                                 = VkResult  function( VkDevice device, const( VkSemaphoreGetZirconHandleInfoFUCHSIA )* pGetZirconHandleInfo, zx_handle_t* pZirconHandle );
        }

        // VK_QNX_screen_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, QNX_screen_surface )) {
            enum VK_QNX_screen_surface = 1;

            enum VK_QNX_SCREEN_SURFACE_SPEC_VERSION = 1;
            enum VK_QNX_SCREEN_SURFACE_EXTENSION_NAME = "VK_QNX_screen_surface";
            
            alias VkScreenSurfaceCreateFlagsQNX = VkFlags;
            
            struct VkScreenSurfaceCreateInfoQNX {
                VkStructureType                sType = VK_STRUCTURE_TYPE_SCREEN_SURFACE_CREATE_INFO_QNX;
                const( void )*                 pNext;
                VkScreenSurfaceCreateFlagsQNX  flags;
                const( _screen_context )*      context;
                const( _screen_window )*       window;
            }
            
            alias PFN_vkCreateScreenSurfaceQNX                                          = VkResult  function( VkInstance instance, const( VkScreenSurfaceCreateInfoQNX )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceScreenPresentationSupportQNX                   = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, const( _screen_window )* window );
        }

        __gshared {

            // VK_KHR_xlib_surface : function pointer decelerations
            static if( __traits( isSame, extension, KHR_xlib_surface )) {
                PFN_vkCreateXlibSurfaceKHR                                            vkCreateXlibSurfaceKHR;
                PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     vkGetPhysicalDeviceXlibPresentationSupportKHR;
            }

            // VK_KHR_xcb_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_xcb_surface )) {
                PFN_vkCreateXcbSurfaceKHR                                             vkCreateXcbSurfaceKHR;
                PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      vkGetPhysicalDeviceXcbPresentationSupportKHR;
            }

            // VK_KHR_wayland_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_wayland_surface )) {
                PFN_vkCreateWaylandSurfaceKHR                                         vkCreateWaylandSurfaceKHR;
                PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  vkGetPhysicalDeviceWaylandPresentationSupportKHR;
            }

            // VK_KHR_android_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_android_surface )) {
                PFN_vkCreateAndroidSurfaceKHR                                         vkCreateAndroidSurfaceKHR;
            }

            // VK_KHR_win32_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_win32_surface )) {
                PFN_vkCreateWin32SurfaceKHR                                           vkCreateWin32SurfaceKHR;
                PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    vkGetPhysicalDeviceWin32PresentationSupportKHR;
            }

            // VK_KHR_video_queue : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_video_queue )) {
                PFN_vkGetPhysicalDeviceVideoCapabilitiesKHR                           vkGetPhysicalDeviceVideoCapabilitiesKHR;
                PFN_vkGetPhysicalDeviceVideoFormatPropertiesKHR                       vkGetPhysicalDeviceVideoFormatPropertiesKHR;
                PFN_vkCreateVideoSessionKHR                                           vkCreateVideoSessionKHR;
                PFN_vkDestroyVideoSessionKHR                                          vkDestroyVideoSessionKHR;
                PFN_vkGetVideoSessionMemoryRequirementsKHR                            vkGetVideoSessionMemoryRequirementsKHR;
                PFN_vkBindVideoSessionMemoryKHR                                       vkBindVideoSessionMemoryKHR;
                PFN_vkCreateVideoSessionParametersKHR                                 vkCreateVideoSessionParametersKHR;
                PFN_vkUpdateVideoSessionParametersKHR                                 vkUpdateVideoSessionParametersKHR;
                PFN_vkDestroyVideoSessionParametersKHR                                vkDestroyVideoSessionParametersKHR;
                PFN_vkCmdBeginVideoCodingKHR                                          vkCmdBeginVideoCodingKHR;
                PFN_vkCmdEndVideoCodingKHR                                            vkCmdEndVideoCodingKHR;
                PFN_vkCmdControlVideoCodingKHR                                        vkCmdControlVideoCodingKHR;
            }

            // VK_KHR_video_decode_queue : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_video_decode_queue )) {
                PFN_vkCmdDecodeVideoKHR                                               vkCmdDecodeVideoKHR;
            }

            // VK_KHR_external_memory_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleKHR                                         vkGetMemoryWin32HandleKHR;
                PFN_vkGetMemoryWin32HandlePropertiesKHR                               vkGetMemoryWin32HandlePropertiesKHR;
            }

            // VK_KHR_external_semaphore_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                PFN_vkImportSemaphoreWin32HandleKHR                                   vkImportSemaphoreWin32HandleKHR;
                PFN_vkGetSemaphoreWin32HandleKHR                                      vkGetSemaphoreWin32HandleKHR;
            }

            // VK_KHR_external_fence_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                PFN_vkImportFenceWin32HandleKHR                                       vkImportFenceWin32HandleKHR;
                PFN_vkGetFenceWin32HandleKHR                                          vkGetFenceWin32HandleKHR;
            }

            // VK_KHR_video_encode_queue : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                PFN_vkCmdEncodeVideoKHR                                               vkCmdEncodeVideoKHR;
            }

            // VK_GGP_stream_descriptor_surface : function pointer decelerations
            else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
                PFN_vkCreateStreamDescriptorSurfaceGGP                                vkCreateStreamDescriptorSurfaceGGP;
            }

            // VK_NV_external_memory_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleNV                                          vkGetMemoryWin32HandleNV;
            }

            // VK_NN_vi_surface : function pointer decelerations
            else static if( __traits( isSame, extension, NN_vi_surface )) {
                PFN_vkCreateViSurfaceNN                                               vkCreateViSurfaceNN;
            }

            // VK_EXT_acquire_xlib_display : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
                PFN_vkAcquireXlibDisplayEXT                                           vkAcquireXlibDisplayEXT;
                PFN_vkGetRandROutputDisplayEXT                                        vkGetRandROutputDisplayEXT;
            }

            // VK_MVK_ios_surface : function pointer decelerations
            else static if( __traits( isSame, extension, MVK_ios_surface )) {
                PFN_vkCreateIOSSurfaceMVK                                             vkCreateIOSSurfaceMVK;
            }

            // VK_MVK_macos_surface : function pointer decelerations
            else static if( __traits( isSame, extension, MVK_macos_surface )) {
                PFN_vkCreateMacOSSurfaceMVK                                           vkCreateMacOSSurfaceMVK;
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : function pointer decelerations
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                PFN_vkGetAndroidHardwareBufferPropertiesANDROID                       vkGetAndroidHardwareBufferPropertiesANDROID;
                PFN_vkGetMemoryAndroidHardwareBufferANDROID                           vkGetMemoryAndroidHardwareBufferANDROID;
            }

            // VK_FUCHSIA_imagepipe_surface : function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
                PFN_vkCreateImagePipeSurfaceFUCHSIA                                   vkCreateImagePipeSurfaceFUCHSIA;
            }

            // VK_EXT_metal_surface : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_metal_surface )) {
                PFN_vkCreateMetalSurfaceEXT                                           vkCreateMetalSurfaceEXT;
            }

            // VK_EXT_full_screen_exclusive : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        vkGetPhysicalDeviceSurfacePresentModes2EXT;
                PFN_vkAcquireFullScreenExclusiveModeEXT                               vkAcquireFullScreenExclusiveModeEXT;
                PFN_vkReleaseFullScreenExclusiveModeEXT                               vkReleaseFullScreenExclusiveModeEXT;
                PFN_vkGetDeviceGroupSurfacePresentModes2EXT                           vkGetDeviceGroupSurfacePresentModes2EXT;
            }

            // VK_NV_acquire_winrt_display : function pointer decelerations
            else static if( __traits( isSame, extension, NV_acquire_winrt_display )) {
                PFN_vkAcquireWinrtDisplayNV                                           vkAcquireWinrtDisplayNV;
                PFN_vkGetWinrtDisplayNV                                               vkGetWinrtDisplayNV;
            }

            // VK_EXT_directfb_surface : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_directfb_surface )) {
                PFN_vkCreateDirectFBSurfaceEXT                                        vkCreateDirectFBSurfaceEXT;
                PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 vkGetPhysicalDeviceDirectFBPresentationSupportEXT;
            }

            // VK_FUCHSIA_external_memory : function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                PFN_vkGetMemoryZirconHandleFUCHSIA                                    vkGetMemoryZirconHandleFUCHSIA;
                PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA                          vkGetMemoryZirconHandlePropertiesFUCHSIA;
            }

            // VK_FUCHSIA_external_semaphore : function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                PFN_vkImportSemaphoreZirconHandleFUCHSIA                              vkImportSemaphoreZirconHandleFUCHSIA;
                PFN_vkGetSemaphoreZirconHandleFUCHSIA                                 vkGetSemaphoreZirconHandleFUCHSIA;
            }

            // VK_QNX_screen_surface : function pointer decelerations
            else static if( __traits( isSame, extension, QNX_screen_surface )) {
                PFN_vkCreateScreenSurfaceQNX                                          vkCreateScreenSurfaceQNX;
                PFN_vkGetPhysicalDeviceScreenPresentationSupportQNX                   vkGetPhysicalDeviceScreenPresentationSupportQNX;
            }
        }
    }

    // workaround for not being able to mixin two overloads with the same symbol name
    alias loadDeviceLevelFunctionsExt = loadDeviceLevelFunctionsExtI;
    alias loadDeviceLevelFunctionsExt = loadDeviceLevelFunctionsExtD;

    // backwards compatibility aliases
    alias loadInstanceLevelFunctions = loadInstanceLevelFunctionsExt;
    alias loadDeviceLevelFunctions = loadDeviceLevelFunctionsExt;
    alias DispatchDevice = DispatchDeviceExt;

    // compose loadInstanceLevelFunctionsExt function out of unextended
    // loadInstanceLevelFunctions and additional function pointers from extensions
    void loadInstanceLevelFunctionsExt( VkInstance instance ) {

        // first load all non platform related function pointers from implementation
        erupted.functions.loadInstanceLevelFunctions( instance );

        // 2. loop through alias sequence and mixin corresponding
        // instance level function pointer definitions
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_xlib_surface : load instance level function definitions
            static if( __traits( isSame, extension, KHR_xlib_surface )) {
                vkCreateXlibSurfaceKHR                                            = cast( PFN_vkCreateXlibSurfaceKHR                                            ) vkGetInstanceProcAddr( instance, "vkCreateXlibSurfaceKHR" );
                vkGetPhysicalDeviceXlibPresentationSupportKHR                     = cast( PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceXlibPresentationSupportKHR" );
            }

            // VK_KHR_xcb_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_xcb_surface )) {
                vkCreateXcbSurfaceKHR                                             = cast( PFN_vkCreateXcbSurfaceKHR                                             ) vkGetInstanceProcAddr( instance, "vkCreateXcbSurfaceKHR" );
                vkGetPhysicalDeviceXcbPresentationSupportKHR                      = cast( PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceXcbPresentationSupportKHR" );
            }

            // VK_KHR_wayland_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_wayland_surface )) {
                vkCreateWaylandSurfaceKHR                                         = cast( PFN_vkCreateWaylandSurfaceKHR                                         ) vkGetInstanceProcAddr( instance, "vkCreateWaylandSurfaceKHR" );
                vkGetPhysicalDeviceWaylandPresentationSupportKHR                  = cast( PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceWaylandPresentationSupportKHR" );
            }

            // VK_KHR_android_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_android_surface )) {
                vkCreateAndroidSurfaceKHR                                         = cast( PFN_vkCreateAndroidSurfaceKHR                                         ) vkGetInstanceProcAddr( instance, "vkCreateAndroidSurfaceKHR" );
            }

            // VK_KHR_win32_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_win32_surface )) {
                vkCreateWin32SurfaceKHR                                           = cast( PFN_vkCreateWin32SurfaceKHR                                           ) vkGetInstanceProcAddr( instance, "vkCreateWin32SurfaceKHR" );
                vkGetPhysicalDeviceWin32PresentationSupportKHR                    = cast( PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceWin32PresentationSupportKHR" );
            }

            // VK_KHR_video_queue : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_video_queue )) {
                vkGetPhysicalDeviceVideoCapabilitiesKHR                           = cast( PFN_vkGetPhysicalDeviceVideoCapabilitiesKHR                           ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceVideoCapabilitiesKHR" );
                vkGetPhysicalDeviceVideoFormatPropertiesKHR                       = cast( PFN_vkGetPhysicalDeviceVideoFormatPropertiesKHR                       ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceVideoFormatPropertiesKHR" );
            }

            // VK_GGP_stream_descriptor_surface : load instance level function definitions
            else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
                vkCreateStreamDescriptorSurfaceGGP                                = cast( PFN_vkCreateStreamDescriptorSurfaceGGP                                ) vkGetInstanceProcAddr( instance, "vkCreateStreamDescriptorSurfaceGGP" );
            }

            // VK_NN_vi_surface : load instance level function definitions
            else static if( __traits( isSame, extension, NN_vi_surface )) {
                vkCreateViSurfaceNN                                               = cast( PFN_vkCreateViSurfaceNN                                               ) vkGetInstanceProcAddr( instance, "vkCreateViSurfaceNN" );
            }

            // VK_EXT_acquire_xlib_display : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
                vkAcquireXlibDisplayEXT                                           = cast( PFN_vkAcquireXlibDisplayEXT                                           ) vkGetInstanceProcAddr( instance, "vkAcquireXlibDisplayEXT" );
                vkGetRandROutputDisplayEXT                                        = cast( PFN_vkGetRandROutputDisplayEXT                                        ) vkGetInstanceProcAddr( instance, "vkGetRandROutputDisplayEXT" );
            }

            // VK_MVK_ios_surface : load instance level function definitions
            else static if( __traits( isSame, extension, MVK_ios_surface )) {
                vkCreateIOSSurfaceMVK                                             = cast( PFN_vkCreateIOSSurfaceMVK                                             ) vkGetInstanceProcAddr( instance, "vkCreateIOSSurfaceMVK" );
            }

            // VK_MVK_macos_surface : load instance level function definitions
            else static if( __traits( isSame, extension, MVK_macos_surface )) {
                vkCreateMacOSSurfaceMVK                                           = cast( PFN_vkCreateMacOSSurfaceMVK                                           ) vkGetInstanceProcAddr( instance, "vkCreateMacOSSurfaceMVK" );
            }

            // VK_FUCHSIA_imagepipe_surface : load instance level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
                vkCreateImagePipeSurfaceFUCHSIA                                   = cast( PFN_vkCreateImagePipeSurfaceFUCHSIA                                   ) vkGetInstanceProcAddr( instance, "vkCreateImagePipeSurfaceFUCHSIA" );
            }

            // VK_EXT_metal_surface : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_metal_surface )) {
                vkCreateMetalSurfaceEXT                                           = cast( PFN_vkCreateMetalSurfaceEXT                                           ) vkGetInstanceProcAddr( instance, "vkCreateMetalSurfaceEXT" );
            }

            // VK_EXT_full_screen_exclusive : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                vkGetPhysicalDeviceSurfacePresentModes2EXT                        = cast( PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceSurfacePresentModes2EXT" );
            }

            // VK_NV_acquire_winrt_display : load instance level function definitions
            else static if( __traits( isSame, extension, NV_acquire_winrt_display )) {
                vkAcquireWinrtDisplayNV                                           = cast( PFN_vkAcquireWinrtDisplayNV                                           ) vkGetInstanceProcAddr( instance, "vkAcquireWinrtDisplayNV" );
                vkGetWinrtDisplayNV                                               = cast( PFN_vkGetWinrtDisplayNV                                               ) vkGetInstanceProcAddr( instance, "vkGetWinrtDisplayNV" );
            }

            // VK_EXT_directfb_surface : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_directfb_surface )) {
                vkCreateDirectFBSurfaceEXT                                        = cast( PFN_vkCreateDirectFBSurfaceEXT                                        ) vkGetInstanceProcAddr( instance, "vkCreateDirectFBSurfaceEXT" );
                vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 = cast( PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceDirectFBPresentationSupportEXT" );
            }

            // VK_QNX_screen_surface : load instance level function definitions
            else static if( __traits( isSame, extension, QNX_screen_surface )) {
                vkCreateScreenSurfaceQNX                                          = cast( PFN_vkCreateScreenSurfaceQNX                                          ) vkGetInstanceProcAddr( instance, "vkCreateScreenSurfaceQNX" );
                vkGetPhysicalDeviceScreenPresentationSupportQNX                   = cast( PFN_vkGetPhysicalDeviceScreenPresentationSupportQNX                   ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceScreenPresentationSupportQNX" );
            }
        }
    }

    // compose instance based loadDeviceLevelFunctionsExtI function out of unextended
    // loadDeviceLevelFunctions and additional function pointers from extensions
    // suffix I is required, as we cannot mixin mixin two overloads with the same symbol name (any more!)
    void loadDeviceLevelFunctionsExtI( VkInstance instance ) {

        // first load all non platform related function pointers from implementation
        erupted.functions.loadDeviceLevelFunctions( instance );

        // 3. loop through alias sequence and mixin corresponding
        // instance based device level function pointer definitions
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_video_queue : load instance based device level function definitions
            static if( __traits( isSame, extension, KHR_video_queue )) {
                vkCreateVideoSessionKHR                           = cast( PFN_vkCreateVideoSessionKHR                           ) vkGetInstanceProcAddr( instance, "vkCreateVideoSessionKHR" );
                vkDestroyVideoSessionKHR                          = cast( PFN_vkDestroyVideoSessionKHR                          ) vkGetInstanceProcAddr( instance, "vkDestroyVideoSessionKHR" );
                vkGetVideoSessionMemoryRequirementsKHR            = cast( PFN_vkGetVideoSessionMemoryRequirementsKHR            ) vkGetInstanceProcAddr( instance, "vkGetVideoSessionMemoryRequirementsKHR" );
                vkBindVideoSessionMemoryKHR                       = cast( PFN_vkBindVideoSessionMemoryKHR                       ) vkGetInstanceProcAddr( instance, "vkBindVideoSessionMemoryKHR" );
                vkCreateVideoSessionParametersKHR                 = cast( PFN_vkCreateVideoSessionParametersKHR                 ) vkGetInstanceProcAddr( instance, "vkCreateVideoSessionParametersKHR" );
                vkUpdateVideoSessionParametersKHR                 = cast( PFN_vkUpdateVideoSessionParametersKHR                 ) vkGetInstanceProcAddr( instance, "vkUpdateVideoSessionParametersKHR" );
                vkDestroyVideoSessionParametersKHR                = cast( PFN_vkDestroyVideoSessionParametersKHR                ) vkGetInstanceProcAddr( instance, "vkDestroyVideoSessionParametersKHR" );
                vkCmdBeginVideoCodingKHR                          = cast( PFN_vkCmdBeginVideoCodingKHR                          ) vkGetInstanceProcAddr( instance, "vkCmdBeginVideoCodingKHR" );
                vkCmdEndVideoCodingKHR                            = cast( PFN_vkCmdEndVideoCodingKHR                            ) vkGetInstanceProcAddr( instance, "vkCmdEndVideoCodingKHR" );
                vkCmdControlVideoCodingKHR                        = cast( PFN_vkCmdControlVideoCodingKHR                        ) vkGetInstanceProcAddr( instance, "vkCmdControlVideoCodingKHR" );
            }

            // VK_KHR_video_decode_queue : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_video_decode_queue )) {
                vkCmdDecodeVideoKHR                               = cast( PFN_vkCmdDecodeVideoKHR                               ) vkGetInstanceProcAddr( instance, "vkCmdDecodeVideoKHR" );
            }

            // VK_KHR_external_memory_win32 : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                vkGetMemoryWin32HandleKHR                         = cast( PFN_vkGetMemoryWin32HandleKHR                         ) vkGetInstanceProcAddr( instance, "vkGetMemoryWin32HandleKHR" );
                vkGetMemoryWin32HandlePropertiesKHR               = cast( PFN_vkGetMemoryWin32HandlePropertiesKHR               ) vkGetInstanceProcAddr( instance, "vkGetMemoryWin32HandlePropertiesKHR" );
            }

            // VK_KHR_external_semaphore_win32 : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                vkImportSemaphoreWin32HandleKHR                   = cast( PFN_vkImportSemaphoreWin32HandleKHR                   ) vkGetInstanceProcAddr( instance, "vkImportSemaphoreWin32HandleKHR" );
                vkGetSemaphoreWin32HandleKHR                      = cast( PFN_vkGetSemaphoreWin32HandleKHR                      ) vkGetInstanceProcAddr( instance, "vkGetSemaphoreWin32HandleKHR" );
            }

            // VK_KHR_external_fence_win32 : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                vkImportFenceWin32HandleKHR                       = cast( PFN_vkImportFenceWin32HandleKHR                       ) vkGetInstanceProcAddr( instance, "vkImportFenceWin32HandleKHR" );
                vkGetFenceWin32HandleKHR                          = cast( PFN_vkGetFenceWin32HandleKHR                          ) vkGetInstanceProcAddr( instance, "vkGetFenceWin32HandleKHR" );
            }

            // VK_KHR_video_encode_queue : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                vkCmdEncodeVideoKHR                               = cast( PFN_vkCmdEncodeVideoKHR                               ) vkGetInstanceProcAddr( instance, "vkCmdEncodeVideoKHR" );
            }

            // VK_NV_external_memory_win32 : load instance based device level function definitions
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                vkGetMemoryWin32HandleNV                          = cast( PFN_vkGetMemoryWin32HandleNV                          ) vkGetInstanceProcAddr( instance, "vkGetMemoryWin32HandleNV" );
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : load instance based device level function definitions
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                vkGetAndroidHardwareBufferPropertiesANDROID       = cast( PFN_vkGetAndroidHardwareBufferPropertiesANDROID       ) vkGetInstanceProcAddr( instance, "vkGetAndroidHardwareBufferPropertiesANDROID" );
                vkGetMemoryAndroidHardwareBufferANDROID           = cast( PFN_vkGetMemoryAndroidHardwareBufferANDROID           ) vkGetInstanceProcAddr( instance, "vkGetMemoryAndroidHardwareBufferANDROID" );
            }

            // VK_EXT_full_screen_exclusive : load instance based device level function definitions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                vkAcquireFullScreenExclusiveModeEXT               = cast( PFN_vkAcquireFullScreenExclusiveModeEXT               ) vkGetInstanceProcAddr( instance, "vkAcquireFullScreenExclusiveModeEXT" );
                vkReleaseFullScreenExclusiveModeEXT               = cast( PFN_vkReleaseFullScreenExclusiveModeEXT               ) vkGetInstanceProcAddr( instance, "vkReleaseFullScreenExclusiveModeEXT" );
                vkGetDeviceGroupSurfacePresentModes2EXT           = cast( PFN_vkGetDeviceGroupSurfacePresentModes2EXT           ) vkGetInstanceProcAddr( instance, "vkGetDeviceGroupSurfacePresentModes2EXT" );
            }

            // VK_FUCHSIA_external_memory : load instance based device level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                vkGetMemoryZirconHandleFUCHSIA                    = cast( PFN_vkGetMemoryZirconHandleFUCHSIA                    ) vkGetInstanceProcAddr( instance, "vkGetMemoryZirconHandleFUCHSIA" );
                vkGetMemoryZirconHandlePropertiesFUCHSIA          = cast( PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA          ) vkGetInstanceProcAddr( instance, "vkGetMemoryZirconHandlePropertiesFUCHSIA" );
            }

            // VK_FUCHSIA_external_semaphore : load instance based device level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                vkImportSemaphoreZirconHandleFUCHSIA              = cast( PFN_vkImportSemaphoreZirconHandleFUCHSIA              ) vkGetInstanceProcAddr( instance, "vkImportSemaphoreZirconHandleFUCHSIA" );
                vkGetSemaphoreZirconHandleFUCHSIA                 = cast( PFN_vkGetSemaphoreZirconHandleFUCHSIA                 ) vkGetInstanceProcAddr( instance, "vkGetSemaphoreZirconHandleFUCHSIA" );
            }
        }
    }

    // compose device based loadDeviceLevelFunctionsExtD function out of unextended
    // loadDeviceLevelFunctions and additional function pointers from extensions
    // suffix D is required as, we cannot mixin mixin two overloads with the same symbol name (any more!)
    void loadDeviceLevelFunctionsExtD( VkDevice device ) {

        // first load all non platform related function pointers from implementation
        erupted.functions.loadDeviceLevelFunctions( device );

        // 4. loop through alias sequence and mixin corresponding
        // device based device level function pointer definitions
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_video_queue : load device based device level function definitions
            static if( __traits( isSame, extension, KHR_video_queue )) {
                vkCreateVideoSessionKHR                           = cast( PFN_vkCreateVideoSessionKHR                           ) vkGetDeviceProcAddr( device, "vkCreateVideoSessionKHR" );
                vkDestroyVideoSessionKHR                          = cast( PFN_vkDestroyVideoSessionKHR                          ) vkGetDeviceProcAddr( device, "vkDestroyVideoSessionKHR" );
                vkGetVideoSessionMemoryRequirementsKHR            = cast( PFN_vkGetVideoSessionMemoryRequirementsKHR            ) vkGetDeviceProcAddr( device, "vkGetVideoSessionMemoryRequirementsKHR" );
                vkBindVideoSessionMemoryKHR                       = cast( PFN_vkBindVideoSessionMemoryKHR                       ) vkGetDeviceProcAddr( device, "vkBindVideoSessionMemoryKHR" );
                vkCreateVideoSessionParametersKHR                 = cast( PFN_vkCreateVideoSessionParametersKHR                 ) vkGetDeviceProcAddr( device, "vkCreateVideoSessionParametersKHR" );
                vkUpdateVideoSessionParametersKHR                 = cast( PFN_vkUpdateVideoSessionParametersKHR                 ) vkGetDeviceProcAddr( device, "vkUpdateVideoSessionParametersKHR" );
                vkDestroyVideoSessionParametersKHR                = cast( PFN_vkDestroyVideoSessionParametersKHR                ) vkGetDeviceProcAddr( device, "vkDestroyVideoSessionParametersKHR" );
                vkCmdBeginVideoCodingKHR                          = cast( PFN_vkCmdBeginVideoCodingKHR                          ) vkGetDeviceProcAddr( device, "vkCmdBeginVideoCodingKHR" );
                vkCmdEndVideoCodingKHR                            = cast( PFN_vkCmdEndVideoCodingKHR                            ) vkGetDeviceProcAddr( device, "vkCmdEndVideoCodingKHR" );
                vkCmdControlVideoCodingKHR                        = cast( PFN_vkCmdControlVideoCodingKHR                        ) vkGetDeviceProcAddr( device, "vkCmdControlVideoCodingKHR" );
            }

            // VK_KHR_video_decode_queue : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_video_decode_queue )) {
                vkCmdDecodeVideoKHR                               = cast( PFN_vkCmdDecodeVideoKHR                               ) vkGetDeviceProcAddr( device, "vkCmdDecodeVideoKHR" );
            }

            // VK_KHR_external_memory_win32 : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                vkGetMemoryWin32HandleKHR                         = cast( PFN_vkGetMemoryWin32HandleKHR                         ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleKHR" );
                vkGetMemoryWin32HandlePropertiesKHR               = cast( PFN_vkGetMemoryWin32HandlePropertiesKHR               ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandlePropertiesKHR" );
            }

            // VK_KHR_external_semaphore_win32 : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                vkImportSemaphoreWin32HandleKHR                   = cast( PFN_vkImportSemaphoreWin32HandleKHR                   ) vkGetDeviceProcAddr( device, "vkImportSemaphoreWin32HandleKHR" );
                vkGetSemaphoreWin32HandleKHR                      = cast( PFN_vkGetSemaphoreWin32HandleKHR                      ) vkGetDeviceProcAddr( device, "vkGetSemaphoreWin32HandleKHR" );
            }

            // VK_KHR_external_fence_win32 : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                vkImportFenceWin32HandleKHR                       = cast( PFN_vkImportFenceWin32HandleKHR                       ) vkGetDeviceProcAddr( device, "vkImportFenceWin32HandleKHR" );
                vkGetFenceWin32HandleKHR                          = cast( PFN_vkGetFenceWin32HandleKHR                          ) vkGetDeviceProcAddr( device, "vkGetFenceWin32HandleKHR" );
            }

            // VK_KHR_video_encode_queue : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                vkCmdEncodeVideoKHR                               = cast( PFN_vkCmdEncodeVideoKHR                               ) vkGetDeviceProcAddr( device, "vkCmdEncodeVideoKHR" );
            }

            // VK_NV_external_memory_win32 : load device based device level function definitions
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                vkGetMemoryWin32HandleNV                          = cast( PFN_vkGetMemoryWin32HandleNV                          ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleNV" );
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : load device based device level function definitions
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                vkGetAndroidHardwareBufferPropertiesANDROID       = cast( PFN_vkGetAndroidHardwareBufferPropertiesANDROID       ) vkGetDeviceProcAddr( device, "vkGetAndroidHardwareBufferPropertiesANDROID" );
                vkGetMemoryAndroidHardwareBufferANDROID           = cast( PFN_vkGetMemoryAndroidHardwareBufferANDROID           ) vkGetDeviceProcAddr( device, "vkGetMemoryAndroidHardwareBufferANDROID" );
            }

            // VK_EXT_full_screen_exclusive : load device based device level function definitions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                vkAcquireFullScreenExclusiveModeEXT               = cast( PFN_vkAcquireFullScreenExclusiveModeEXT               ) vkGetDeviceProcAddr( device, "vkAcquireFullScreenExclusiveModeEXT" );
                vkReleaseFullScreenExclusiveModeEXT               = cast( PFN_vkReleaseFullScreenExclusiveModeEXT               ) vkGetDeviceProcAddr( device, "vkReleaseFullScreenExclusiveModeEXT" );
                vkGetDeviceGroupSurfacePresentModes2EXT           = cast( PFN_vkGetDeviceGroupSurfacePresentModes2EXT           ) vkGetDeviceProcAddr( device, "vkGetDeviceGroupSurfacePresentModes2EXT" );
            }

            // VK_FUCHSIA_external_memory : load device based device level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                vkGetMemoryZirconHandleFUCHSIA                    = cast( PFN_vkGetMemoryZirconHandleFUCHSIA                    ) vkGetDeviceProcAddr( device, "vkGetMemoryZirconHandleFUCHSIA" );
                vkGetMemoryZirconHandlePropertiesFUCHSIA          = cast( PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA          ) vkGetDeviceProcAddr( device, "vkGetMemoryZirconHandlePropertiesFUCHSIA" );
            }

            // VK_FUCHSIA_external_semaphore : load device based device level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                vkImportSemaphoreZirconHandleFUCHSIA              = cast( PFN_vkImportSemaphoreZirconHandleFUCHSIA              ) vkGetDeviceProcAddr( device, "vkImportSemaphoreZirconHandleFUCHSIA" );
                vkGetSemaphoreZirconHandleFUCHSIA                 = cast( PFN_vkGetSemaphoreZirconHandleFUCHSIA                 ) vkGetDeviceProcAddr( device, "vkGetSemaphoreZirconHandleFUCHSIA" );
            }
        }
    }

    // compose extended dispatch device out of unextended original dispatch device with
    // extended, device based loadDeviceLevelFunctionsExt member function,
    // device and command buffer based function pointer decelerations
    struct DispatchDeviceExt {

        // use unextended dispatch device from module erupted.functions as member and alias this
        erupted.dispatch_device.DispatchDevice commonDispatchDevice;
        alias commonDispatchDevice this;

        // Constructor forwards parameter 'device' to 'loadDeviceLevelFunctionsExt'
        this( VkDevice device ) {
            loadDeviceLevelFunctionsExt( device );
        }

        // backwards compatibility alias
        alias loadDeviceLevelFunctions = loadDeviceLevelFunctionsExt;

        // compose device based loadDeviceLevelFunctionsExt member function out of unextended
        // loadDeviceLevelFunctions and additional member function pointers from extensions
        void loadDeviceLevelFunctionsExt( VkDevice device ) {

            // first load all non platform related member function pointers of wrapped commonDispatchDevice
            commonDispatchDevice.loadDeviceLevelFunctions( device );

            // 5. loop through alias sequence and mixin corresponding
            // device level member function pointer definitions of this wrapping DispatchDevice
            static foreach( extension; noDuplicateExtensions ) {

                // VK_KHR_video_queue : load dispatch device member function definitions
                static if( __traits( isSame, extension, KHR_video_queue )) {
                    vkCreateVideoSessionKHR                           = cast( PFN_vkCreateVideoSessionKHR                           ) vkGetDeviceProcAddr( device, "vkCreateVideoSessionKHR" );
                    vkDestroyVideoSessionKHR                          = cast( PFN_vkDestroyVideoSessionKHR                          ) vkGetDeviceProcAddr( device, "vkDestroyVideoSessionKHR" );
                    vkGetVideoSessionMemoryRequirementsKHR            = cast( PFN_vkGetVideoSessionMemoryRequirementsKHR            ) vkGetDeviceProcAddr( device, "vkGetVideoSessionMemoryRequirementsKHR" );
                    vkBindVideoSessionMemoryKHR                       = cast( PFN_vkBindVideoSessionMemoryKHR                       ) vkGetDeviceProcAddr( device, "vkBindVideoSessionMemoryKHR" );
                    vkCreateVideoSessionParametersKHR                 = cast( PFN_vkCreateVideoSessionParametersKHR                 ) vkGetDeviceProcAddr( device, "vkCreateVideoSessionParametersKHR" );
                    vkUpdateVideoSessionParametersKHR                 = cast( PFN_vkUpdateVideoSessionParametersKHR                 ) vkGetDeviceProcAddr( device, "vkUpdateVideoSessionParametersKHR" );
                    vkDestroyVideoSessionParametersKHR                = cast( PFN_vkDestroyVideoSessionParametersKHR                ) vkGetDeviceProcAddr( device, "vkDestroyVideoSessionParametersKHR" );
                    vkCmdBeginVideoCodingKHR                          = cast( PFN_vkCmdBeginVideoCodingKHR                          ) vkGetDeviceProcAddr( device, "vkCmdBeginVideoCodingKHR" );
                    vkCmdEndVideoCodingKHR                            = cast( PFN_vkCmdEndVideoCodingKHR                            ) vkGetDeviceProcAddr( device, "vkCmdEndVideoCodingKHR" );
                    vkCmdControlVideoCodingKHR                        = cast( PFN_vkCmdControlVideoCodingKHR                        ) vkGetDeviceProcAddr( device, "vkCmdControlVideoCodingKHR" );
                }

                // VK_KHR_video_decode_queue : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_video_decode_queue )) {
                    vkCmdDecodeVideoKHR                               = cast( PFN_vkCmdDecodeVideoKHR                               ) vkGetDeviceProcAddr( device, "vkCmdDecodeVideoKHR" );
                }

                // VK_KHR_external_memory_win32 : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                    vkGetMemoryWin32HandleKHR                         = cast( PFN_vkGetMemoryWin32HandleKHR                         ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleKHR" );
                    vkGetMemoryWin32HandlePropertiesKHR               = cast( PFN_vkGetMemoryWin32HandlePropertiesKHR               ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandlePropertiesKHR" );
                }

                // VK_KHR_external_semaphore_win32 : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                    vkImportSemaphoreWin32HandleKHR                   = cast( PFN_vkImportSemaphoreWin32HandleKHR                   ) vkGetDeviceProcAddr( device, "vkImportSemaphoreWin32HandleKHR" );
                    vkGetSemaphoreWin32HandleKHR                      = cast( PFN_vkGetSemaphoreWin32HandleKHR                      ) vkGetDeviceProcAddr( device, "vkGetSemaphoreWin32HandleKHR" );
                }

                // VK_KHR_external_fence_win32 : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                    vkImportFenceWin32HandleKHR                       = cast( PFN_vkImportFenceWin32HandleKHR                       ) vkGetDeviceProcAddr( device, "vkImportFenceWin32HandleKHR" );
                    vkGetFenceWin32HandleKHR                          = cast( PFN_vkGetFenceWin32HandleKHR                          ) vkGetDeviceProcAddr( device, "vkGetFenceWin32HandleKHR" );
                }

                // VK_KHR_video_encode_queue : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                    vkCmdEncodeVideoKHR                               = cast( PFN_vkCmdEncodeVideoKHR                               ) vkGetDeviceProcAddr( device, "vkCmdEncodeVideoKHR" );
                }

                // VK_NV_external_memory_win32 : load dispatch device member function definitions
                else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                    vkGetMemoryWin32HandleNV                          = cast( PFN_vkGetMemoryWin32HandleNV                          ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleNV" );
                }

                // VK_ANDROID_external_memory_android_hardware_buffer : load dispatch device member function definitions
                else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                    vkGetAndroidHardwareBufferPropertiesANDROID       = cast( PFN_vkGetAndroidHardwareBufferPropertiesANDROID       ) vkGetDeviceProcAddr( device, "vkGetAndroidHardwareBufferPropertiesANDROID" );
                    vkGetMemoryAndroidHardwareBufferANDROID           = cast( PFN_vkGetMemoryAndroidHardwareBufferANDROID           ) vkGetDeviceProcAddr( device, "vkGetMemoryAndroidHardwareBufferANDROID" );
                }

                // VK_EXT_full_screen_exclusive : load dispatch device member function definitions
                else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                    vkAcquireFullScreenExclusiveModeEXT               = cast( PFN_vkAcquireFullScreenExclusiveModeEXT               ) vkGetDeviceProcAddr( device, "vkAcquireFullScreenExclusiveModeEXT" );
                    vkReleaseFullScreenExclusiveModeEXT               = cast( PFN_vkReleaseFullScreenExclusiveModeEXT               ) vkGetDeviceProcAddr( device, "vkReleaseFullScreenExclusiveModeEXT" );
                    vkGetDeviceGroupSurfacePresentModes2EXT           = cast( PFN_vkGetDeviceGroupSurfacePresentModes2EXT           ) vkGetDeviceProcAddr( device, "vkGetDeviceGroupSurfacePresentModes2EXT" );
                }

                // VK_FUCHSIA_external_memory : load dispatch device member function definitions
                else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                    vkGetMemoryZirconHandleFUCHSIA                    = cast( PFN_vkGetMemoryZirconHandleFUCHSIA                    ) vkGetDeviceProcAddr( device, "vkGetMemoryZirconHandleFUCHSIA" );
                    vkGetMemoryZirconHandlePropertiesFUCHSIA          = cast( PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA          ) vkGetDeviceProcAddr( device, "vkGetMemoryZirconHandlePropertiesFUCHSIA" );
                }

                // VK_FUCHSIA_external_semaphore : load dispatch device member function definitions
                else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                    vkImportSemaphoreZirconHandleFUCHSIA              = cast( PFN_vkImportSemaphoreZirconHandleFUCHSIA              ) vkGetDeviceProcAddr( device, "vkImportSemaphoreZirconHandleFUCHSIA" );
                    vkGetSemaphoreZirconHandleFUCHSIA                 = cast( PFN_vkGetSemaphoreZirconHandleFUCHSIA                 ) vkGetDeviceProcAddr( device, "vkGetSemaphoreZirconHandleFUCHSIA" );
                }
            }
        }

        // 6. loop through alias sequence and mixin corresponding convenience member functions
        // omitting device parameter of this wrapping DispatchDevice. Member vkDevice of commonDispatchDevice is used instead
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_video_queue : dispatch device convenience member functions
            static if( __traits( isSame, extension, KHR_video_queue )) {
                VkResult  CreateVideoSessionKHR( const( VkVideoSessionCreateInfoKHR )* pCreateInfo, VkVideoSessionKHR* pVideoSession ) { return vkCreateVideoSessionKHR( vkDevice, pCreateInfo, pAllocator, pVideoSession ); }
                void      DestroyVideoSessionKHR( VkVideoSessionKHR videoSession ) { vkDestroyVideoSessionKHR( vkDevice, videoSession, pAllocator ); }
                VkResult  GetVideoSessionMemoryRequirementsKHR( VkVideoSessionKHR videoSession, uint32_t* pVideoSessionMemoryRequirementsCount, VkVideoGetMemoryPropertiesKHR* pVideoSessionMemoryRequirements ) { return vkGetVideoSessionMemoryRequirementsKHR( vkDevice, videoSession, pVideoSessionMemoryRequirementsCount, pVideoSessionMemoryRequirements ); }
                VkResult  BindVideoSessionMemoryKHR( VkVideoSessionKHR videoSession, uint32_t videoSessionBindMemoryCount, const( VkVideoBindMemoryKHR )* pVideoSessionBindMemories ) { return vkBindVideoSessionMemoryKHR( vkDevice, videoSession, videoSessionBindMemoryCount, pVideoSessionBindMemories ); }
                VkResult  CreateVideoSessionParametersKHR( const( VkVideoSessionParametersCreateInfoKHR )* pCreateInfo, VkVideoSessionParametersKHR* pVideoSessionParameters ) { return vkCreateVideoSessionParametersKHR( vkDevice, pCreateInfo, pAllocator, pVideoSessionParameters ); }
                VkResult  UpdateVideoSessionParametersKHR( VkVideoSessionParametersKHR videoSessionParameters, const( VkVideoSessionParametersUpdateInfoKHR )* pUpdateInfo ) { return vkUpdateVideoSessionParametersKHR( vkDevice, videoSessionParameters, pUpdateInfo ); }
                void      DestroyVideoSessionParametersKHR( VkVideoSessionParametersKHR videoSessionParameters ) { vkDestroyVideoSessionParametersKHR( vkDevice, videoSessionParameters, pAllocator ); }
                void      CmdBeginVideoCodingKHR( const( VkVideoBeginCodingInfoKHR )* pBeginInfo ) { vkCmdBeginVideoCodingKHR( commandBuffer, pBeginInfo ); }
                void      CmdEndVideoCodingKHR( const( VkVideoEndCodingInfoKHR )* pEndCodingInfo ) { vkCmdEndVideoCodingKHR( commandBuffer, pEndCodingInfo ); }
                void      CmdControlVideoCodingKHR( const( VkVideoCodingControlInfoKHR )* pCodingControlInfo ) { vkCmdControlVideoCodingKHR( commandBuffer, pCodingControlInfo ); }
            }

            // VK_KHR_video_decode_queue : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_video_decode_queue )) {
                void      CmdDecodeVideoKHR( const( VkVideoDecodeInfoKHR )* pFrameInfo ) { vkCmdDecodeVideoKHR( commandBuffer, pFrameInfo ); }
            }

            // VK_KHR_external_memory_win32 : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                VkResult  GetMemoryWin32HandleKHR( const( VkMemoryGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle ) { return vkGetMemoryWin32HandleKHR( vkDevice, pGetWin32HandleInfo, pHandle ); }
                VkResult  GetMemoryWin32HandlePropertiesKHR( VkExternalMemoryHandleTypeFlagBits handleType, HANDLE handle, VkMemoryWin32HandlePropertiesKHR* pMemoryWin32HandleProperties ) { return vkGetMemoryWin32HandlePropertiesKHR( vkDevice, handleType, handle, pMemoryWin32HandleProperties ); }
            }

            // VK_KHR_external_semaphore_win32 : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                VkResult  ImportSemaphoreWin32HandleKHR( const( VkImportSemaphoreWin32HandleInfoKHR )* pImportSemaphoreWin32HandleInfo ) { return vkImportSemaphoreWin32HandleKHR( vkDevice, pImportSemaphoreWin32HandleInfo ); }
                VkResult  GetSemaphoreWin32HandleKHR( const( VkSemaphoreGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle ) { return vkGetSemaphoreWin32HandleKHR( vkDevice, pGetWin32HandleInfo, pHandle ); }
            }

            // VK_KHR_external_fence_win32 : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                VkResult  ImportFenceWin32HandleKHR( const( VkImportFenceWin32HandleInfoKHR )* pImportFenceWin32HandleInfo ) { return vkImportFenceWin32HandleKHR( vkDevice, pImportFenceWin32HandleInfo ); }
                VkResult  GetFenceWin32HandleKHR( const( VkFenceGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle ) { return vkGetFenceWin32HandleKHR( vkDevice, pGetWin32HandleInfo, pHandle ); }
            }

            // VK_KHR_video_encode_queue : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                void      CmdEncodeVideoKHR( const( VkVideoEncodeInfoKHR )* pEncodeInfo ) { vkCmdEncodeVideoKHR( commandBuffer, pEncodeInfo ); }
            }

            // VK_NV_external_memory_win32 : dispatch device convenience member functions
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                VkResult  GetMemoryWin32HandleNV( VkDeviceMemory memory, VkExternalMemoryHandleTypeFlagsNV handleType, HANDLE* pHandle ) { return vkGetMemoryWin32HandleNV( vkDevice, memory, handleType, pHandle ); }
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : dispatch device convenience member functions
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                VkResult  GetAndroidHardwareBufferPropertiesANDROID( const( AHardwareBuffer )* buffer, VkAndroidHardwareBufferPropertiesANDROID* pProperties ) { return vkGetAndroidHardwareBufferPropertiesANDROID( vkDevice, buffer, pProperties ); }
                VkResult  GetMemoryAndroidHardwareBufferANDROID( const( VkMemoryGetAndroidHardwareBufferInfoANDROID )* pInfo, AHardwareBuffer pBuffer ) { return vkGetMemoryAndroidHardwareBufferANDROID( vkDevice, pInfo, pBuffer ); }
            }

            // VK_EXT_full_screen_exclusive : dispatch device convenience member functions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                VkResult  AcquireFullScreenExclusiveModeEXT( VkSwapchainKHR swapchain ) { return vkAcquireFullScreenExclusiveModeEXT( vkDevice, swapchain ); }
                VkResult  ReleaseFullScreenExclusiveModeEXT( VkSwapchainKHR swapchain ) { return vkReleaseFullScreenExclusiveModeEXT( vkDevice, swapchain ); }
                VkResult  GetDeviceGroupSurfacePresentModes2EXT( const( VkPhysicalDeviceSurfaceInfo2KHR )* pSurfaceInfo, VkDeviceGroupPresentModeFlagsKHR* pModes ) { return vkGetDeviceGroupSurfacePresentModes2EXT( vkDevice, pSurfaceInfo, pModes ); }
            }

            // VK_FUCHSIA_external_memory : dispatch device convenience member functions
            else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                VkResult  GetMemoryZirconHandleFUCHSIA( const( VkMemoryGetZirconHandleInfoFUCHSIA )* pGetZirconHandleInfo, zx_handle_t* pZirconHandle ) { return vkGetMemoryZirconHandleFUCHSIA( vkDevice, pGetZirconHandleInfo, pZirconHandle ); }
                VkResult  GetMemoryZirconHandlePropertiesFUCHSIA( VkExternalMemoryHandleTypeFlagBits handleType, zx_handle_t zirconHandle, VkMemoryZirconHandlePropertiesFUCHSIA* pMemoryZirconHandleProperties ) { return vkGetMemoryZirconHandlePropertiesFUCHSIA( vkDevice, handleType, zirconHandle, pMemoryZirconHandleProperties ); }
            }

            // VK_FUCHSIA_external_semaphore : dispatch device convenience member functions
            else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                VkResult  ImportSemaphoreZirconHandleFUCHSIA( const( VkImportSemaphoreZirconHandleInfoFUCHSIA )* pImportSemaphoreZirconHandleInfo ) { return vkImportSemaphoreZirconHandleFUCHSIA( vkDevice, pImportSemaphoreZirconHandleInfo ); }
                VkResult  GetSemaphoreZirconHandleFUCHSIA( const( VkSemaphoreGetZirconHandleInfoFUCHSIA )* pGetZirconHandleInfo, zx_handle_t* pZirconHandle ) { return vkGetSemaphoreZirconHandleFUCHSIA( vkDevice, pGetZirconHandleInfo, pZirconHandle ); }
            }
        }

        // 7. loop last time through alias sequence and mixin corresponding function pointer declarations
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_xlib_surface : dispatch device member function pointer decelerations
            static if( __traits( isSame, extension, KHR_xlib_surface )) {
                PFN_vkCreateXlibSurfaceKHR                                            vkCreateXlibSurfaceKHR;
                PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     vkGetPhysicalDeviceXlibPresentationSupportKHR;
            }

            // VK_KHR_xcb_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_xcb_surface )) {
                PFN_vkCreateXcbSurfaceKHR                                             vkCreateXcbSurfaceKHR;
                PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      vkGetPhysicalDeviceXcbPresentationSupportKHR;
            }

            // VK_KHR_wayland_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_wayland_surface )) {
                PFN_vkCreateWaylandSurfaceKHR                                         vkCreateWaylandSurfaceKHR;
                PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  vkGetPhysicalDeviceWaylandPresentationSupportKHR;
            }

            // VK_KHR_android_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_android_surface )) {
                PFN_vkCreateAndroidSurfaceKHR                                         vkCreateAndroidSurfaceKHR;
            }

            // VK_KHR_win32_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_win32_surface )) {
                PFN_vkCreateWin32SurfaceKHR                                           vkCreateWin32SurfaceKHR;
                PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    vkGetPhysicalDeviceWin32PresentationSupportKHR;
            }

            // VK_KHR_video_queue : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_video_queue )) {
                PFN_vkGetPhysicalDeviceVideoCapabilitiesKHR                           vkGetPhysicalDeviceVideoCapabilitiesKHR;
                PFN_vkGetPhysicalDeviceVideoFormatPropertiesKHR                       vkGetPhysicalDeviceVideoFormatPropertiesKHR;
                PFN_vkCreateVideoSessionKHR                                           vkCreateVideoSessionKHR;
                PFN_vkDestroyVideoSessionKHR                                          vkDestroyVideoSessionKHR;
                PFN_vkGetVideoSessionMemoryRequirementsKHR                            vkGetVideoSessionMemoryRequirementsKHR;
                PFN_vkBindVideoSessionMemoryKHR                                       vkBindVideoSessionMemoryKHR;
                PFN_vkCreateVideoSessionParametersKHR                                 vkCreateVideoSessionParametersKHR;
                PFN_vkUpdateVideoSessionParametersKHR                                 vkUpdateVideoSessionParametersKHR;
                PFN_vkDestroyVideoSessionParametersKHR                                vkDestroyVideoSessionParametersKHR;
                PFN_vkCmdBeginVideoCodingKHR                                          vkCmdBeginVideoCodingKHR;
                PFN_vkCmdEndVideoCodingKHR                                            vkCmdEndVideoCodingKHR;
                PFN_vkCmdControlVideoCodingKHR                                        vkCmdControlVideoCodingKHR;
            }

            // VK_KHR_video_decode_queue : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_video_decode_queue )) {
                PFN_vkCmdDecodeVideoKHR                                               vkCmdDecodeVideoKHR;
            }

            // VK_KHR_external_memory_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleKHR                                         vkGetMemoryWin32HandleKHR;
                PFN_vkGetMemoryWin32HandlePropertiesKHR                               vkGetMemoryWin32HandlePropertiesKHR;
            }

            // VK_KHR_external_semaphore_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                PFN_vkImportSemaphoreWin32HandleKHR                                   vkImportSemaphoreWin32HandleKHR;
                PFN_vkGetSemaphoreWin32HandleKHR                                      vkGetSemaphoreWin32HandleKHR;
            }

            // VK_KHR_external_fence_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                PFN_vkImportFenceWin32HandleKHR                                       vkImportFenceWin32HandleKHR;
                PFN_vkGetFenceWin32HandleKHR                                          vkGetFenceWin32HandleKHR;
            }

            // VK_KHR_video_encode_queue : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_video_encode_queue )) {
                PFN_vkCmdEncodeVideoKHR                                               vkCmdEncodeVideoKHR;
            }

            // VK_GGP_stream_descriptor_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
                PFN_vkCreateStreamDescriptorSurfaceGGP                                vkCreateStreamDescriptorSurfaceGGP;
            }

            // VK_NV_external_memory_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleNV                                          vkGetMemoryWin32HandleNV;
            }

            // VK_NN_vi_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, NN_vi_surface )) {
                PFN_vkCreateViSurfaceNN                                               vkCreateViSurfaceNN;
            }

            // VK_EXT_acquire_xlib_display : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
                PFN_vkAcquireXlibDisplayEXT                                           vkAcquireXlibDisplayEXT;
                PFN_vkGetRandROutputDisplayEXT                                        vkGetRandROutputDisplayEXT;
            }

            // VK_MVK_ios_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, MVK_ios_surface )) {
                PFN_vkCreateIOSSurfaceMVK                                             vkCreateIOSSurfaceMVK;
            }

            // VK_MVK_macos_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, MVK_macos_surface )) {
                PFN_vkCreateMacOSSurfaceMVK                                           vkCreateMacOSSurfaceMVK;
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                PFN_vkGetAndroidHardwareBufferPropertiesANDROID                       vkGetAndroidHardwareBufferPropertiesANDROID;
                PFN_vkGetMemoryAndroidHardwareBufferANDROID                           vkGetMemoryAndroidHardwareBufferANDROID;
            }

            // VK_FUCHSIA_imagepipe_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
                PFN_vkCreateImagePipeSurfaceFUCHSIA                                   vkCreateImagePipeSurfaceFUCHSIA;
            }

            // VK_EXT_metal_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_metal_surface )) {
                PFN_vkCreateMetalSurfaceEXT                                           vkCreateMetalSurfaceEXT;
            }

            // VK_EXT_full_screen_exclusive : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        vkGetPhysicalDeviceSurfacePresentModes2EXT;
                PFN_vkAcquireFullScreenExclusiveModeEXT                               vkAcquireFullScreenExclusiveModeEXT;
                PFN_vkReleaseFullScreenExclusiveModeEXT                               vkReleaseFullScreenExclusiveModeEXT;
                PFN_vkGetDeviceGroupSurfacePresentModes2EXT                           vkGetDeviceGroupSurfacePresentModes2EXT;
            }

            // VK_NV_acquire_winrt_display : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, NV_acquire_winrt_display )) {
                PFN_vkAcquireWinrtDisplayNV                                           vkAcquireWinrtDisplayNV;
                PFN_vkGetWinrtDisplayNV                                               vkGetWinrtDisplayNV;
            }

            // VK_EXT_directfb_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_directfb_surface )) {
                PFN_vkCreateDirectFBSurfaceEXT                                        vkCreateDirectFBSurfaceEXT;
                PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 vkGetPhysicalDeviceDirectFBPresentationSupportEXT;
            }

            // VK_FUCHSIA_external_memory : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_external_memory )) {
                PFN_vkGetMemoryZirconHandleFUCHSIA                                    vkGetMemoryZirconHandleFUCHSIA;
                PFN_vkGetMemoryZirconHandlePropertiesFUCHSIA                          vkGetMemoryZirconHandlePropertiesFUCHSIA;
            }

            // VK_FUCHSIA_external_semaphore : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_external_semaphore )) {
                PFN_vkImportSemaphoreZirconHandleFUCHSIA                              vkImportSemaphoreZirconHandleFUCHSIA;
                PFN_vkGetSemaphoreZirconHandleFUCHSIA                                 vkGetSemaphoreZirconHandleFUCHSIA;
            }

            // VK_QNX_screen_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, QNX_screen_surface )) {
                PFN_vkCreateScreenSurfaceQNX                                          vkCreateScreenSurfaceQNX;
                PFN_vkGetPhysicalDeviceScreenPresentationSupportQNX                   vkGetPhysicalDeviceScreenPresentationSupportQNX;
            }
        }
    }
}
