Shader "Fog/ExponentialHeightFog"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			#include "FogCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
				float4 vertex : SV_POSITION;

                float2 uv : TEXCOORD0;
				UBPA_FOG_COORDS(1)
            };

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				UBPA_TRANSFER_FOG(o, v.vertex);

                return o;
            }

            fixed4 frag (v2f IN) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, IN.uv);
				UBPA_APPLY_FOG(IN, col);
				return col;
            }
            ENDCG
        }
    }
}
