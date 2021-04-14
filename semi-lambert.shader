// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "dly/semi-lambert"
{
    Properties
    {
        _Diffuse ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass{

            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM

            #include "Lighting.cginc" //取得一个直射光的颜色 _LightColor0, 第一个直射光的位置 _WorldSpaceLightPos0
        
            #pragma vertex vert

            #pragma fragment frag

            fixed4 _Diffuse;

            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };

            struct v2f{
                float4 position: SV_POSITION;
                fixed3 WorldNormalDir: TEXCOORD;
            };

            v2f vert(a2v v){
                v2f f;
                f.position = UnityObjectToClipPos(v.vertex);
                f.WorldNormalDir = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                return f;
            }

            fixed4 frag(v2f f): SV_Target{
                fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffuse = _LightColor0.rgb * (dot(lightDir, f.WorldNormalDir) * 0.5 + 0.5) * _Diffuse;

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
            
                fixed3 color = diffuse + ambient;

                return fixed4 (color, 1);
            }
            ENDCG

        }
        

        
    }
    FallBack "Diffuse"
}
