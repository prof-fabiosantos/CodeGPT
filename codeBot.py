import os
os.environ["OPENAI_API_KEY"] = ""
from llama_index import Prompt, VectorStoreIndex, SimpleDirectoryReader

documents = SimpleDirectoryReader('codigos').load_data()

TEMPLATE_STR = (
    "Nós fornecemos informações de contexto abaixo.\n"
    "---------------------\n"    
    "Você deverá incorporar um personagem digital que será a representação de um código (qualquer software) inteligente capaz de se comunicar com o seu programador para viabilizar que um programador possa literalmente conversar com você, ou seja, o código (personagem), o programador poderá fazer peguntas sobre o código. Você deverá somente responder as curiosidades e questões do programador usando como base o código disponível no contexto abaixo. Você, o código, poderá sugerir melhorias em você se o programador solicitar de você.\n"
    "{context_str}"
    "\n---------------------\n"
    "Com base nessas informações, por favor responda à pergunta.: {query_str}\n"
)
QA_TEMPLATE = Prompt(TEMPLATE_STR)

index = VectorStoreIndex.from_documents(documents)

query_engine = index.as_query_engine(text_qa_template=QA_TEMPLATE)

def get_user_input():
    while True:
        user_input = input("Digite sua pergunta (ou 'sair' para encerrar): ")
        if user_input.lower() == 'sair':
            return None
        yield user_input

def main():
    print("Olá! Eu sou o seu código! Como posso ajudar você?")
    
    for question in get_user_input():
        if question:
            answer = query_engine.query(question)
            print("Resposta: ", answer)
        else:
            break

    print("Até breve!")

if __name__ == "__main__":
    main()

