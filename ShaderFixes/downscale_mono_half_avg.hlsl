Texture2D<float> t110 : register(t110);

void main(float4 pos : SV_Position0, out float result : SV_Target0)
{
	float x = floor(pos.x) * 2;
	float y = floor(pos.y) * 2;

	float4 p;
	p.x = t110.Load(float3(x + 0, y + 0, 0));
	p.y = t110.Load(float3(x + 1, y + 0, 0));
	p.z = t110.Load(float3(x + 0, y + 1, 0));
	p.w = t110.Load(float3(x + 1, y + 1, 0));
	float count = dot(!!p, 1);
	result = count ? dot(p, 1) / count : 0;
}
