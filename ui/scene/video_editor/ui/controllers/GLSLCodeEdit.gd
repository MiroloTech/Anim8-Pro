extends CodeEdit

var data_types : Array[String] = ['void', 'bool', 'int', 'uint', 'float', 'double', 'bvec2', 'bvec3', 'bvec4', 'ivec2', 'ivec3', 'ivec4', 'uvec2', 'uvec3', 'uvec4', 'vec2', 'vec3', 'vec4', 'dvec2', 'dvec3', 'dvec4', 'mat2', 'mat3', 'mat4', 'mat2x2', 'mat2x3', 'mat2x4', 'mat3x2', 'mat3x3', 'mat3x4', 'mat4x2', 'mat4x3', 'mat4x4', 'sampler1D', 'sampler2D', 'sampler3D', 'samplerCube', 'sampler2DRect', 'sampler1DArray', 'sampler2DArray', 'samplerCubeArray', 'samplerBuffer', 'sampler2DMS', 'sampler2DMSArray', 'isampler1D', 'isampler2D', 'isampler3D', 'isamplerCube', 'isampler2DRect', 'isampler1DArray', 'isampler2DArray', 'isamplerCubeArray', 'isamplerBuffer', 'isampler2DMS', 'isampler2DMSArray', 'usampler1D', 'usampler2D', 'usampler3D', 'usamplerCube', 'usampler2DRect', 'usampler1DArray', 'usampler2DArray', 'usamplerCubeArray', 'usamplerBuffer', 'usampler2DMS', 'usampler2DMSArray']
var qualifiers : Array[String] = ['const', 'uniform', 'attribute', 'varying', 'in', 'out', 'inout', 'smooth', 'flat', 'noperspective', 'centroid', 'patch', 'sample', 'subroutine']
var control_flow : Array[String] = ['if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'return', 'discard']
var functions : Array[String] = ['sin', 'asin', 'sinh', 'asinh', 'cos', 'acos', 'cosh', 'acosh', 'tan', 'atan', 'tanh', 'atanh', 'abs', 'sign', 'floor', 'ceil', 'fract', 'mod', 'min', 'max', 'clamp', 'mix', 'step', 'smoothstep', 'length', 'distance', 'dot', 'cross', 'normalize', 'faceforward', 'reflect', 'refract', 'matrixCompMult', 'lessThan', 'lessThanEqual', 'greaterThan', 'greaterThanEqual', 'equal', 'notEqual', 'any', 'all', 'not', 'dFdx', 'dFdy', 'fwidth', 'texture', 'textureSize', 'textureProj', 'textureLod', 'textureProjLod', 'textureGrad', 'textureProjGrad', 'textureQueryLod', 'textureQueryLevels']
var operators : Array[String] = ['+', '-', '*', '/', '%', '++', '--', '=', '+=', '-=', '*=', '/=', '%=', '==', '!=', '<', '>', '<=', '>=', '!', '&&', '||', '&', '|', '^', '<<', '>>', '~', '.', '->', '[]', '()']
# var builtin_variables : Array[String] = ['gl_VertexID', 'gl_InstanceID', 'gl_Position', 'gl_PointSize', 'gl_FragCoord', 'gl_FrontFacing', 'gl_FragColor', 'gl_FragData', 'gl_FragDepth', 'gl_ClipDistance', 'gl_TexCoord', 'gl_MultiTexCoord', 'gl_FogFragCoord', 'gl_FogCoord', 'gl_Color', 'gl_SecondaryColor', 'gl_Normal', 'gl_Vertex', 'gl_ModelViewMatrix', 'gl_ProjectionMatrix', 'gl_ModelViewProjectionMatrix', 'gl_TextureMatrix', 'gl_NormalMatrix', 'gl_ModelViewMatrixInverse', 'gl_ProjectionMatrixInverse', 'gl_ModelViewProjectionMatrixInverse', 'gl_TextureMatrixInverse', 'gl_ModelViewMatrixTranspose', 'gl_ProjectionMatrixTranspose', 'gl_ModelViewProjectionMatrixTranspose', 'gl_TextureMatrixTranspose', 'gl_ModelViewMatrixInverseTranspose', 'gl_ProjectionMatrixInverseTranspose', 'gl_ModelViewProjectionMatrixInverseTranspose', 'gl_TextureMatrixInverseTranspose', 'gl_DepthRange', 'gl_FogParams', 'gl_FogColor', 'gl_FrontColor', 'gl_BackColor', 'gl_FrontSecondaryColor', 'gl_BackSecondaryColor', 'gl_TexCoordIn[]', 'gl_FogFragCoordIn[]', 'gl_ColorIn[]', 'gl_SecondaryColorIn[]', 'gl_NormalIn[]', 'gl_VertexIn[]', 'gl_InvocationID', 'gl_PrimitiveID', 'gl_PrimitiveIDIn', 'gl_Layer', 'gl_ViewportIndex', 'gl_TessLevelOuter[]', 'gl_TessLevelInner[]', 'gl_TessCoord', 'gl_PatchVerticesIn', 'gl_InvocationID', 'gl_PrimitiveID', 'gl_TessLevelOuter', 'gl_TessLevelInner', 'gl_VertexIndex', 'gl_InstanceIndex', 'gl_BaseVertex', 'gl_BaseInstance', 'gl_PositionPerViewNV', 'gl_ViewID', 'gl_ViewportMaskNV', 'gl_PerVertex', 'gl_PerPrimitive', 'gl_LastFragData', 'gl_LastFragColor', 'gl_LastFragDepth', 'gl_LastFragStencilRef', 'gl_MaxVaryingComponents', 'gl_MaxVertexOutputComponents', 'gl_MaxGeometryInputComponents', 'gl_MaxGeometryOutputComponents', 'gl_MaxFragmentInputComponents', 'gl_MaxVertexTextureImageUnits', 'gl_MaxCombinedTextureImageUnits', 'gl_MaxDrawBuffers', 'gl_MaxClipPlanes', 'gl_MaxVertexAttribs', 'gl_MaxTextureCoords', 'gl_MaxTextureUnits', 'gl_MaxTextureImageUnits', 'gl_MaxImageUnits', 'gl_MaxSamples', 'gl_MaxComputeUniformComponents', 'gl_MaxComputeAtomicCounterBuffers', 'gl_MaxComputeAtomicCounters', 'gl_MaxComputeImageUniforms', 'gl_MaxComputeTextureImageUnits', 'gl_MaxComputeSharedMemorySize', 'gl_MaxComputeUniformComponents', 'gl_MaxComputeAtomicCounterBuffers', 'gl_MaxComputeAtomicCounters', 'gl_MaxComputeImageUniforms', 'gl_MaxComputeTextureImageUnits', 'gl_MaxComputeUniformBlocks', 'gl_MaxComputeUniformComponents', 'gl_MaxComputeAtomicCounterBuffers', 'gl_MaxComputeAtomicCounters', 'gl_MaxComputeImageUniforms', 'gl_MaxComputeTextureImageUnits', 'gl_MaxComputeUniformBlocks', 'gl_MaxComputeUniformComponents', 'gl_MaxComputeAtomicCounterBuffers', 'gl_MaxComputeAtomicCounters', 'gl_MaxComputeImageUniforms', 'gl_MaxComputeTextureImageUnits', 'gl_MaxComputeUniformBlocks', 'gl_MaxComputeUniformComponents', 'gl_MaxComputeAtomicCounterBuffers', 'gl_MaxComputeAtomicCounters', 'gl_MaxComputeImageUniforms', 'gl_MaxComputeTextureImageUnits', 'gl_MaxComputeUniformBlocks', 'gl_MaxComputeWorkGroupCount', 'gl_MaxComputeWorkGroupSize']
var preprocessor_directives : Array[String] = ['#define', '#undef', '#if', '#ifdef', '#ifndef', '#else', '#elif', '#endif', '#error', '#pragma', '#extension', '#version', '#include']
var regions = [["//", "", "#8b8f98"], ["/*", "*/", "#8b8f98"], ["'", "'", "#e9d96d"]]

var keyword_color : Color = Color('#dd5584')
var symbol_color : Color = Color('#91e2ed')
var function_color : Color = Color('#3de6b3')
var number_color : Color = Color('#ac9cec')


# Runs at start of program
func _ready():
	init_color()

# Initialize Coloring of Code
func init_color():
	# Create base coloring instance
	var stx : CodeHighlighter = CodeHighlighter.new()
	syntax_highlighter = stx
	
	# Set Word-Specific Colors
	# Keywords
	for k in qualifiers + data_types + control_flow + functions:
		stx.add_keyword_color(k, keyword_color)
	# Members
	for r in regions:
		stx.add_color_region(r[0], r[1], r[2])
	
	# Set Base colors
	stx.number_color = number_color
	stx.symbol_color = symbol_color
	stx.function_color = function_color
	stx.member_variable_color = Color.WHITE
