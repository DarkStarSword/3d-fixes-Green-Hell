Texture2D<float> ZBuffer : register(t110);

void main(
		float4 pos : SV_Position0,
		float4 spos : TEXCOORD1,
		float2 tpos : TEXCOORD2,
		out float result : SV_Target0)
{
	uint tex_width, tex_height;

	// First pass just does a nearest type downscale - we don't care about
	// quality, we just need enough samples that we don't miss any major
	// object.

	ZBuffer.GetDimensions(tex_width, tex_height);

	spos.xy *= 0.5;
	tpos = spos.xy * float2(0.5,-0.5) + 0.5;
	float x = tpos.x * tex_width;
	float y = tpos.y * tex_height;

	result = ZBuffer.Load(int3(x, y, 0));
}
