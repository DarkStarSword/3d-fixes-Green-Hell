Texture2D<float4> StereoParams : register(t125);
Texture1D<float4> IniParams : register(t120);

#include "crosshair.hlsl"

#define amplify IniParams[0].x
#define flip IniParams[0].y

struct vs2ps {
	float4 pos : SV_Position0;
	float2 spos : TEXCOORD1;
};

#ifdef VERTEX_SHADER
void main(
		out vs2ps output,
		uint vertex : SV_VertexID)
{
	// Not using vertex buffers so manufacture our own coordinates.
	switch(vertex) {
		case 0:
			output.pos.xy = float2(-1, -1);
			break;
		case 1:
			output.pos.xy = float2(-1, 1);
			break;
		case 2:
			output.pos.xy = float2(1, -1);
			break;
		case 3:
			output.pos.xy = float2(1, 1);
			break;
		default:
			output.pos.xy = 0;
			break;
	};
	output.pos.zw = float2(0, 1);
	output.spos = output.pos.xy;
}
#endif

#ifdef PIXEL_SHADER
void main(vs2ps input, out float4 result : SV_Target0)
{
	if (flip)
		input.spos.y = -input.spos.y;

	float convergence = StereoParams.Load(0).y;
	result = world_z_from_depth_buffer(input.spos.x, input.spos.y) / convergence;

	if (result.x > 1.0) {
		// Normally this would be invisible, but we want to see it, so
		// rescale the green and blue channels:
		result.y = (result.x - 1.0) / 10.0;
		result.z = (result.x - 11.0) / 100.0;
	}
}
#endif
