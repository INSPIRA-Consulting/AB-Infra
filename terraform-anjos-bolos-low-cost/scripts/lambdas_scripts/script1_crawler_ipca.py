import pandas as pd
import requests
import zipfile
import io
import os
import xlrd
import boto3
from datetime import datetime
import logging

# Configuração de logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def padronizar_dados_ipca(df_original, nome_arquivo):
    """
    Padroniza dados do IPCA removendo headers desnecessários e preenchendo anos em branco
    Estrutura esperada: ANO aparece apenas na primeira linha, depois só os meses
    """
    try:
        df = df_original.copy()
        
        # Encontrar linha onde começam os dados reais (procurar por "ANO")
        linha_inicio = None
        for i in range(len(df)):
            for col in df.columns:
                valor = str(df.iloc[i, col]).strip().upper()
                if valor == 'ANO':
                    linha_inicio = i + 1  # Pular a linha do cabeçalho
                    break
            if linha_inicio is not None:
                break
        
        # Se não encontrar "ANO", procurar primeira linha com número (ano)
        if linha_inicio is None:
            for i in range(len(df)):
                primeiro_valor = str(df.iloc[i, 0]).strip()
                if primeiro_valor.replace('.', '').isdigit() and len(primeiro_valor) >= 4:
                    linha_inicio = i
                    break
        
        # Se ainda não encontrou, usar a partir da linha 5
        if linha_inicio is None:
            linha_inicio = 5
        
        # Extrair dados a partir da linha identificada
        df_dados = df.iloc[linha_inicio:].reset_index(drop=True)
        
        # Definir colunas padronizadas com nomes mais entendíveis
        colunas_padrao = [
            'ANO', 'MES', 'INDICE_BASE_DEZ_1993', 'VARIACAO_MENSAL',
            'VARIACAO_3_MESES', 'VARIACAO_6_MESES', 'VARIACAO_ANUAL', 'VARIACAO_12_MESES'
        ]
        
        # Ajustar número de colunas disponíveis
        num_colunas = min(len(df_dados.columns), len(colunas_padrao))
        df_dados.columns = colunas_padrao[:num_colunas]
        
        # Lista de meses válidos
        meses_validos = ['JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 
                        'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
                        'JANEIRO', 'FEVEREIRO', 'MARÇO', 'ABRIL', 'MAIO', 'JUNHO',
                        'JULHO', 'AGOSTO', 'SETEMBRO', 'OUTUBRO', 'NOVEMBRO', 'DEZEMBRO']
        
        # Processar linha por linha, preenchendo anos em branco
        ano_atual = None
        linhas_validas = []
        
        for i in range(len(df_dados)):
            linha = df_dados.iloc[i].copy()
            valor_ano = str(linha['ANO']).strip()
            valor_mes = str(linha['MES']).strip() if 'MES' in linha else ''
            
            # Verificar se é um ano válido (4 dígitos)
            if valor_ano.replace('.', '').replace(',', '').isdigit():
                ano_numeric = valor_ano.replace('.', '').replace(',', '')
                if len(ano_numeric) >= 4:
                    ano_atual = int(float(valor_ano))
                    linha['ANO'] = ano_atual
                    
                    # Se tem mês válido, incluir linha
                    if valor_mes.upper() in meses_validos:
                        linhas_validas.append(linha)
                        
            elif ano_atual is not None:
                # Linha sem ano, usar o último ano válido
                linha['ANO'] = ano_atual
                
                # Verificar se o "ANO" é na verdade um mês
                if valor_ano.upper() in meses_validos:
                    linha['MES'] = valor_ano
                    linhas_validas.append(linha)
                elif valor_mes.upper() in meses_validos:
                    linhas_validas.append(linha)
        
        # Criar DataFrame com linhas válidas
        if linhas_validas:
            df_final = pd.DataFrame(linhas_validas).reset_index(drop=True)
        else:
            # Fallback: usar a lógica original
            ano_atual = None
            for i in range(len(df_dados)):
                valor_ano = str(df_dados.loc[i, 'ANO']).strip()
                valor_mes = str(df_dados.loc[i, 'MES']).strip() if 'MES' in df_dados.columns else ''
                
                if valor_ano.replace('.', '').replace(',', '').isdigit() and len(valor_ano.replace('.', '').replace(',', '')) >= 4:
                    ano_atual = int(float(valor_ano))
                    df_dados.loc[i, 'ANO'] = ano_atual
                elif ano_atual is not None and valor_mes.upper() in meses_validos:
                    df_dados.loc[i, 'ANO'] = ano_atual
            
            df_final = df_dados
        
        # Filtrar apenas linhas válidas
        df_final = df_final[df_final['ANO'].notna()]
        df_final = df_final[pd.to_numeric(df_final['ANO'], errors='coerce').notna()]
        df_final = df_final[df_final['MES'].notna()]
        df_final = df_final[df_final['MES'].astype(str).str.strip() != '']
        df_final = df_final[df_final['MES'].astype(str).str.upper() != 'NAN']
        df_final = df_final[df_final['MES'].astype(str).str.upper().isin(meses_validos)]
        
        # Converter ANO para inteiro
        df_final['ANO'] = df_final['ANO'].astype(int)
        
        # Dicionário para converter nomes dos meses para números
        meses_para_numero = {
            'JAN': 1, 'JANEIRO': 1,
            'FEV': 2, 'FEVEREIRO': 2,
            'MAR': 3, 'MARÇO': 3,
            'ABR': 4, 'ABRIL': 4,
            'MAI': 5, 'MAIO': 5,
            'JUN': 6, 'JUNHO': 6,
            'JUL': 7, 'JULHO': 7,
            'AGO': 8, 'AGOSTO': 8,
            'SET': 9, 'SETEMBRO': 9,
            'OUT': 10, 'OUTUBRO': 10,
            'NOV': 11, 'NOVEMBRO': 11,
            'DEZ': 12, 'DEZEMBRO': 12
        }
        
        # Converter mês para número
        df_final['MES'] = df_final['MES'].astype(str).str.upper().map(meses_para_numero)
        
        # Limpar colunas numéricas
        colunas_numericas = ['INDICE_BASE_DEZ_1993', 'VARIACAO_MENSAL', 'VARIACAO_3_MESES', 
                            'VARIACAO_6_MESES', 'VARIACAO_ANUAL', 'VARIACAO_12_MESES']
        
        for col in colunas_numericas:
            if col in df_final.columns:
                df_final[col] = pd.to_numeric(df_final[col], errors='coerce')
        
        # Renomear colunas para o padrão solicitado
        df_final = df_final.rename(columns={
            'ANO': 'ano',
            'MES': 'mes',
            'INDICE_BASE_DEZ_1993': 'indice',
            'VARIACAO_MENSAL': 'variacao_mensal',
            'VARIACAO_3_MESES': 'variacao_trimestral',
            'VARIACAO_6_MESES': 'variacao_semestral',
            'VARIACAO_ANUAL': 'variacao_anual',
            'VARIACAO_12_MESES': 'variacao_doze_meses'
        })
        
        # Selecionar apenas as colunas desejadas
        colunas_desejadas = ['ano', 'mes', 'indice', 'variacao_mensal', 
                           'variacao_trimestral', 'variacao_semestral', 
                           'variacao_anual', 'variacao_doze_meses']
        
        # Manter apenas colunas que existem
        colunas_existentes = [col for col in colunas_desejadas if col in df_final.columns]
        df_final = df_final[colunas_existentes]
        
        # Remover linhas completamente vazias
        df_final = df_final.dropna(how='all')
        
        # Verificar se temos dados de vários meses
        meses_unicos = df_final['mes'].nunique() if 'mes' in df_final.columns else 0
        anos_unicos = df_final['ano'].nunique() if 'ano' in df_final.columns else 0
        
        print(f"✅ Dados padronizados - {len(df_final)} registros")
        if 'ano' in df_final.columns:
            print(f"📅 Período: {df_final['ano'].min()}-{df_final['ano'].max()}")
        print(f"📊 Anos únicos: {anos_unicos}, Meses únicos: {meses_unicos}")
        if 'mes' in df_final.columns:
            print(f"🗓️ Meses encontrados: {sorted(df_final['mes'].unique())}")
        print(f"📋 Colunas finais: {list(df_final.columns)}")
        
        return df_final
        
    except Exception as e:
        print(f"❌ Erro ao padronizar dados de {nome_arquivo}: {e}")
        return None

url_ipca = "https://ftp.ibge.gov.br/Precos_Indices_de_Precos_ao_Consumidor/IPCA/Serie_Historica/ipca_SerieHist.zip"

def salvar_no_s3(df, nome_arquivo, bucket_name):
    """
    Salva DataFrame no S3 como CSV
    """
    try:
        s3 = boto3.client('s3')
        
        # Converter DataFrame para CSV
        csv_data = df.to_csv(index=False, encoding='utf-8')
        
        # Definir chave S3
        arquivo_s3 = f"ipca-raw/{nome_arquivo}"
        
        # Upload para S3
        s3.put_object(
            Bucket=bucket_name,
            Key=arquivo_s3,
            Body=csv_data,
            ContentType='text/csv',
            Metadata={
                'fonte': 'ibge-ipca-serie-historica',
                'processado': datetime.now().isoformat(),
                'registros': str(len(df))
            }
        )
        
        logger.info(f"✅ Arquivo salvo no S3: s3://{bucket_name}/{arquivo_s3}")
        return True
        
    except Exception as e:
        logger.error(f"❌ Erro ao salvar no S3: {e}")
        return False

def lambda_handler(event, context):
    """
    Função handler para AWS Lambda
    """
    try:
        bucket_name = os.environ.get('S3_BUCKET_NAME')
        if not bucket_name:
            return {
                'statusCode': 400,
                'body': {'erro': 'Bucket S3 não configurado'}
            }
        
        resultado = processar_ipca_completo(bucket_name)
        
        return {
            'statusCode': 200,
            'body': {
                'mensagem': 'Processamento IPCA concluído com sucesso',
                'resultado': resultado
            }
        }
    except Exception as e:
        logger.error(f"Erro na execução da Lambda: {str(e)}")
        return {
            'statusCode': 500,
            'body': {'error': str(e)}
        }

def processar_ipca_completo(bucket_name=None):
    """
    Função principal que processa IPCA e salva local ou S3
    """
    usar_s3 = bucket_name is not None
    sucessos = 0
    erros = 0
    
    logger.info("🚀 Iniciando download e processamento do IPCA...")

    try:
        # Usar /tmp/ no Lambda, diretório local em execução normal
        if usar_s3:
            temp_dir = "/tmp/ipca-raw"
        else:
            temp_dir = "ipca-raw"
        
        os.makedirs(temp_dir, exist_ok=True)
        
        response = requests.get(url_ipca)
        response.raise_for_status()
        
        with zipfile.ZipFile(io.BytesIO(response.content)) as pasta_zip:
            # Listar arquivos no ZIP
            file_list = pasta_zip.namelist()
            print(f"Arquivos encontrados no ZIP: {file_list}")
            
            for file_name in file_list:
                if file_name.endswith('.xls') or file_name.endswith('.xlsx'):
                    with pasta_zip.open(file_name) as zip_file:
                        file_content = zip_file.read()
                    
                    workbook = xlrd.open_workbook(file_contents=file_content)
                    print(f"Lendo arquivo: {file_name}")
                    sheet = workbook.sheet_by_index(0)  # Primeira planilha
                    data = []
                    for row in range(sheet.nrows):
                        data.append([sheet.cell_value(row, col) for col in range(sheet.ncols)])
                    print("Salvando dados em DataFrame pandas...")
                    df_pandas = pd.DataFrame(data)
                    
                    excel_file = os.path.join(temp_dir, os.path.splitext(file_name)[0] + ".xlsx")
                    df_pandas.to_excel(excel_file, index=False)
                    print(f"Arquivo salvo: {excel_file}")

                    # Processar e padronizar dados
                    csv_padronizado = padronizar_dados_ipca(df_pandas, file_name)
                    if csv_padronizado is not None:
                        nome_arquivo = os.path.splitext(file_name)[0] + "_padronizado.csv"
                        
                        if usar_s3:
                            # Salvar no S3
                            if salvar_no_s3(csv_padronizado, nome_arquivo, bucket_name):
                                sucessos += 1
                            else:
                                erros += 1
                        else:
                            # Salvar local como antes
                            csv_file = os.path.join(temp_dir, nome_arquivo)
                            csv_padronizado.to_csv(csv_file, index=False, encoding='utf-8')
                            print(f"CSV padronizado salvo: {csv_file}")
                            sucessos += 1
                    
        print("Download e extração do IPCA concluídos com sucesso!")
        
        resultado = {
            'sucessos': sucessos,
            'erros': erros,
            'usando_s3': usar_s3
        }
        
        logger.info(f"🎯 Processamento concluído: {resultado}")
        return resultado

    except Exception as e:
        logger.error(f"❌ Erro no processamento: {e}")
        return {'erro': str(e)}

if __name__ == "__main__":
    # Execução local sem S3
    processar_ipca_completo()
