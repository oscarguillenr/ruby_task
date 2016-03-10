# Universidad Simón Bolívar
# Departamento de Computación y Tecnología de la Información
# CI-3661 - Lab. de Lenguajes de Programación I.
#
# Tarea de Ruby
#
# Implementación de la Búsqueda Generalizada:
# 							* Árboles y grafos.
# 							* Recorrido BFS.
# 							* Árboles implícitos.
#
# Autores: 			Gabriel Iglesias 11-10xxx
# 		   			Oscar Guillen    11-11264
# Última edición: 	10 de marzo de 2016.

# Módulo para el recorrido BFS.
module BFS

	# NOTA: Método auxiliar.
	# Método que recorre la estructura desde start
	# haciendo uso del algoritmo de BFS.
	def traveling(start)
		queue = [start]
		visited = []
		while !queue.empty?
			head = queue.shift
			if !visited.include? head
				# Agregando los hijos a la cola.
				head.each {|child| queue.push(child)}
				yield head
				visited << head
			end
		end
	end

	# Usando el método traveling, va recorriendo la estructura
	# usando BFS, buscando el primer elemento que cumpla con
	# el predicado dado.
	def find(start,predicate)
		start.traveling(start) do |result|
			if predicate.call(result)
				return result
			end
		end
		# Se retorna nulo si no se encontró el elemento.
		nil
	end

	# Usando el método traveling, va recorriendo la estructura usando
	# BFS, construyendo el camino desde start hasta encontrar el elemento
	# que cumpla con el predicado dado.
	def path(start,predicate)
		route = {}
		route.store(start,[])
		start.traveling(start) do |result|
    		if predicate.call(result)
    			return route[result] << result
    		end
    		result.each {|child| route.store(child,route[result] << result)}
    	end
    	# Se retorna nulo en caso de no encontrar el elemento.
    	nil
	end

	# Usando el método traveling, va recorriendo la esctructura usando
	# BFS, aplicando la acción a cada nodo retornado por traveling
	# y retornando todos los nodos listados.
	def walk(start,action)
		visited = []
		start.traveling(start) do |result|
			action.call(result)
			visited << result
		end
		# Se retorna la lista de nodos visitados.
		visited
	end
end

# Implementación de la clase Árbol Binario
class BinTree
	include BFS

	attr_accessor :value, 	# Valor almacenado en el nodo
				  :left, 	# BinTree izquierdo
				  :right 	# BinTree derecho
	def initialize(v,l,r)
		@value = v
		@left = l
		@right = r
	end
	def each(b)
		if @left != nil
			yield @left
		end
		if @right != nil
			yield @right
		end
	end
end

# Implementación de la clase Grado de arreglo de Nodos.
class GraphNode
	include BFS

	attr_accessor :value,	# Valor alamacenado en el nodo
				  :children # Arreglo de sucesores GraphNode
	def initialize(v,c)
		@value = v
		@children = c
	end
	def each(b)
		if @children != nil
			@children.each do |child|
				yield child
			end
		end
	end
end