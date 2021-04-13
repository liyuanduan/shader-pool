// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "dly/漫反射"{

    Properties{ //外部可以调节的属性
       /* _Color("Color", Color) = (1, 1, 1, 1)
        _Vector("Vector", Vector) = (1, 1, 1, 1)
        _Int("int", Int) = 123
        _Float("float", FLoat) = 2.123
        _Rang("range", Range(1, 11)) = 6
        _2D("texture", 2D) = "white"{} //如果不指定图片，则默认是个白色的图片
        _Cube("Cube", Cube) = "white"{}
        _3D("3d", 3D) = "red"{}*/

    }

    SubShader{ // subshader可以有很多个，控制效果，不同的subshader可以在不同的显卡上运行，如果第一个subshader可以实现，则使用第一个subshader
        Pass{ //至少有一个pass，在里面编写shader
            Tags{"LightMode" = "ForwardBase"}

            CGPROGRAM //使用cg写shader

               /*float4 _Color; //float, half, fixed 可以相互代替
                float4 _Vector; //float = 32byte
                float _Int;     //half = 16位 -6万 到 6万
                float _Float;   //fixed = 11位 -2 到 +2
                float _Range;
                sampler2D _2D;
                samplerCube _Cube;
                sampler3D _3D;*/
                #include "Lighting.cginc" //取得一个直射光的颜色 _LightColor0, 第一个直射光的位置 _WorldSpaceLightPos0

                #pragma vertex vert //顶点函数，把顶点位置映射到对应剪裁（屏幕）空间，处理位置

                #pragma fragment frag // 片元函数，像素着色器，处理颜色

                struct a2v { //application to vertex
                    float4 vertex: POSITION; //把模型空间下的顶点坐标给vertex
                    float3 normal: NORMAL;   //把模型空间下的法线方向给normal
                    //float4 texcoord: TEXCOORD0; //把第一套纹理坐标给texcoord
                };

                struct v2f {
                    float4 position: SV_POSITION;
                    float3 color: COLOR0; //这个语义可以由用户自己定义，一般都存储颜色

                };

                v2f vert(a2v v){
                    v2f f;
                    f.position = UnityObjectToClipPos(v.vertex);
                    //float4 pos = mul(UNITY_MATRIX_MVP, v);
                    
                    fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                    fixed3 normalDir = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

                    fixed3 diffuse = _LightColor0.rgb * max( dot(lightDir, normalDir), 0);
                    f.color = diffuse;

                    return f;
                }

                fixed4 frag(v2f f) :SV_Target{
                    return fixed4(f.color, 1);
                }

            ENDCG

        }
    }

    Fallback "Specular" //后备方案，如果没有一个subshader可以使用，则使用这个已存在的shader

}
/*
Shader "Custom/01shader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf Standard fullforwardshadows

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

            sampler2D _MainTex;

            struct Input
            {
                float2 uv_MainTex;
            };

            half _Glossiness;
            half _Metallic;
            fixed4 _Color;

            // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
            // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
            // #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props)

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                // Albedo comes from a texture tinted by color
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                o.Albedo = c.rgb;
                // Metallic and smoothness come from slider variables
                o.Metallic = _Metallic;
                o.Smoothness = _Glossiness;
                o.Alpha = c.a;
            }
            ENDCG
        }
            FallBack "Diffuse"
}*/
