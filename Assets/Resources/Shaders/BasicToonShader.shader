﻿Shader "Custom/BasicToonShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Tint ("Tint Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_OutlineColor ("Outline Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_OutlineThickness ("Outline Thickness", Range(0.0, 1.0)) = 0.1
		
	}
	SubShader {
		Pass{
			CGPROGRAM
			#pragma vertex vertexShaderMain
			#pragma fragment fragmentShaderMain

			uniform sampler2D _MainTex;
			uniform float4 _Tint;
			uniform float4 _OutlineColor;
			uniform half _OutlineThickness;
			
			struct vertexInput {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 color : COLOR;
				float4 texcoord : TEXCOORD0;
			};
			
			struct vertexOutput {
				float4 position : SV_POSITION;
				float4 color : COLOR;
				float4 tex : TEXCOORD0;
				float4 posWorld : TEXCOORD1;
				float3 normalDir : TEXCOORD2;
			};

			vertexOutput vertexShaderMain(vertexInput input) {
				vertexOutput output;
				
				output.position = mul(UNITY_MATRIX_MVP, input.vertex);
				output.tex = input.texcoord;
				output.posWorld = mul(_Object2World, input.vertex);
				float3 view = normalize(_WorldSpaceCameraPos - output.posWorld);
				output.normalDir = normalize(mul(float4(input.normal, 0.0), _World2Object).xyz);
				
				output.color.r = output.normalDir.x;
				output.color.g = output.normalDir.y;
				output.color.b = output.position.z/10.0;
				
				return output;
			}
			
			float4 fragmentShaderMain(vertexOutput o) : COLOR{
				float4 tex = tex2D(_MainTex, o.tex.xy);
				
				//float3 view = normalize(_WorldSpaceCameraPos - o.posWorld);
				//bool edgeDetection = (dot(view, o.normalDir) > _OutlineThickness) ? true : false;
				
				
				//if(edgeDetection){
					//return float4(o.normalDir, 1.0);
					//return _Tint * float4(tex.xyz, 1.0);
				//}else{
					//return float4(o.normalDir, 1.0);
				//}
				return o.color;
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
