# A interface Builder especifica métodos para criar diferentes partes dos
# objetos Produtos.
class Builder
  # @abstract
  def produce_part_a
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def produce_part_b
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def produce_part_c
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# As classes do Concrete Builder (construtor) seguem a interface do Builder e fornecem específicas
# implementações das etapas de construção. Seu programa pode ter várias
# variações de construtores, implementadas de forma diferente.
class ConcreteBuilder1 < Builder
  # Uma nova instância do construtor (Builder) deve conter um objeto de produto em branco, que é
  # usado na montagem posteriormente.
  def initialize
    reset
  end

  def reset
    @product = Product1.new
  end

  # Os Concrete Builder (construtor) devem fornecer seus próprios métodos para recuperar
  # resultados. Isso porque vários tipos de construtores podem criar 
  # diferentes produtos que não seguem a mesma interface. Portanto, tais
  # métodos não podem ser declarados na interface do construtor base (pelo menos em uma
  # linguagem de programação estaticamente tipada).
  #
  # Geralmente, depois de retornar o resultado final para o cliente, uma instância do construtor 
  # deve está pronta para produzir outro produto. É por isso que é uma
  # chamar o método reset no final do corpo do método getProduct
  #  No entanto, esse comportamento não é obrigatório, e você pode fazer os seus
  # construtores aguardarem uma chamada de redefinição (reset) explícita do código do cliente antes de
  # descartar o resultado anterior.
  def product
    product = @product
    reset
    product
  end

  def produce_part_a
    @product.add('PartA1')
  end

  def produce_part_b
    @product.add('PartB1')
  end

  def produce_part_c
    @product.add('PartC1')
  end
end

# Faz sentido usar o padrão Builder somente quando seus produtos são bastante
# complexos e requerem uma configuração extensiva.
#
# Ao contário de outros padrões de criação, diferentes Concrete Builder (construtores de concreto) podem produzir
# produtos não relacionados. Em outras plavras, os resultados de vários construtores nem sempre
# seguem a mesma interface.
class Product1
  def initialize
    @parts = []
  end

  # @param [String] part
  def add(part)
    @parts << part
  end

  def list_parts
    print "Product parts: #{@parts.join(', ')}"
  end
end

# O Diretor (Director) é responsável apenas pela execução das etapas de construção em uma
# sequência particular. É útil ao produzir produtos de acordo com uma
# ordem ou configuração específica. Estritamente falando, a classe Director é
# opcional, desde que o cliente possa controlar os construtores diretamente
class Director
  # @return [Builder]
  attr_accessor :builder

  def initialize
    @builder = nil
  end

  # O diretor funciona com qualquer instância do construtor que o código do cliente passe
  # Desta forma, o código do cliente pode alterar o tipo final do
  # produto recém montado.
  def builder=(builder)
    @builder = builder
  end

  # O diretor pode construir várias variações do produto usando as mesmas
  # etapas de construção.

  def build_minimal_viable_product
    @builder.produce_part_a
  end

  def build_full_featured_product
    @builder.produce_part_a
    @builder.produce_part_b
    @builder.produce_part_c
  end
end

# O código do cliente cria um objeto construtor, passa para o diretor e, em seguida,
# inicia o processo de construção. O resultado final é recuperado do 
# objeto construtor.

director = Director.new
builder = ConcreteBuilder1.new
director.builder = builder

puts 'Standard basic product: '
director.build_minimal_viable_product
builder.product.list_parts

puts "\n\n"

puts 'Standard full featured product: '
director.build_full_featured_product
builder.product.list_parts

puts "\n\n"

# Lembre-se, o padrão Builder pode ser usado sem uma classe Diretor (Director)
puts 'Custom product: '
builder.produce_part_a
builder.produce_part_b
builder.product.list_parts