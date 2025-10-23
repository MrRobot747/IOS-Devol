import Foundation

// Part 1.1 — Product

struct Product {
    let id: String
    let name: String
    var price: Double
    let category: Category
    let description: String

    enum Category {
        case electronics
        case clothing
        case food
        case books
    }

    // Витринная цена как строка
    var displayPrice: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale.current
        return f.string(from: NSNumber(value: price)) ?? "\(price)"
    }

    // Валидация: цена > 0
    init?(id: String, name: String, price: Double, category: Category, description: String) {
        guard price > 0 else { return nil }
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.description = description
    }
}


// Part 1.2 — CartItem

struct CartItem {
    var product: Product
    private(set) var quantity: Int

    // Подсумма
    var subtotal: Double {
        product.price * Double(quantity)
    }

    // Обновить количество (валидация > 0)
    mutating func updateQuantity(_ newQuantity: Int) {
        precondition(newQuantity > 0, "Quantity must be > 0")
        quantity = newQuantity
    }

    // Увеличить количество на amount (> 0)
    mutating func increaseQuantity(by amount: Int) {
        precondition(amount > 0, "Increase amount must be > 0")
        quantity += amount
    }

    init(product: Product, quantity: Int) {
        precondition(quantity > 0, "Quantity must be > 0")
        self.product = product
        self.quantity = quantity
    }
}


// Part 2 — ShoppingCart (class)

final class ShoppingCart {
    // Публичное чтение, внутреннее изменение
    private(set) var items: [CartItem] = []
    var discountCode: String?

    init() {}

    // Найти индекс позиции по productId
    private func indexOf(productId: String) -> Int? {
        items.firstIndex { $0.product.id == productId }
    }

    // Добавить товар; если уже существует — увеличить количество
    func addItem(product: Product, quantity: Int) {
        precondition(quantity > 0, "Quantity must be > 0")
        if let idx = indexOf(productId: product.id) {
            items[idx].increaseQuantity(by: quantity)
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
    }

    // Обновить количество существующего товара
    func updateItemQuantity(productId: String, quantity: Int) {
        precondition(quantity > 0, "Quantity must be > 0")
        if let idx = indexOf(productId: productId) {
            items[idx].updateQuantity(quantity)
        }
    }

    // Удалить товар по id
    func removeItem(productId: String) {
        if let idx = indexOf(productId: productId) {
            items.remove(at: idx)
        }
    }

    // Очистить корзину
    func clearCart() {
        items.removeAll()
    }

    // Сумма без скидки
    var subtotal: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }

    // Сумма скидки по коду (простая система)
    var discountAmount: Double {
        guard let code = discountCode?.uppercased() else { return 0 }
        switch code {
        case "SAVE10":
            return subtotal * 0.10
        case "SAVE20":
            return subtotal * 0.20
        default:
            return 0
        }
    }

    // Итог с учётом скидки
    var total: Double {
        max(0, subtotal - discountAmount)
    }

    // Общее число единиц товара
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var isEmpty: Bool { items.isEmpty }
}


// Part 3 — Address & Order


// 3.1 Address
struct Address {
    let street: String
    let city: String
    let zipCode: String
    let country: String

    var formattedAddress: String {
        """
        \(street)
        \(zipCode) \(city)
        \(country)
        """
    }
}

// 3.2 Order — неизменяемый снимок корзины на момент оформления
struct Order {
    // Все свойства — let (иммутабельность)
    let orderId: String
    let items: [CartItem]
    let subtotal: Double
    let discountAmount: Double
    let total: Double
    let timestamp: Date
    let shippingAddress: Address

    // Кол-во позиций (единиц) в заказе
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    // Создание снимка из корзины
    init(from cart: ShoppingCart, shippingAddress: Address) {
        self.orderId = UUID().uuidString
        self.items = cart.items // копия текущих позиций
        self.subtotal = cart.subtotal
        self.discountAmount = cart.discountAmount
        self.total = cart.total
        self.timestamp = Date()
        self.shippingAddress = shippingAddress
    }
}




// Sample products
let laptop = Product(id: "p1", name: "Macbook Pro 14", price: 1499.99, category: .electronics, description: "Powerful laptop")!
let book = Product(id: "p2", name: "Little Prince", price: 29.99, category: .books, description: "Fairy tale")!
let headphones = Product(id: "p3", name: "Headphones", price: 99.90, category: .electronics, description: "Wireless")!

// Cart ops
let cart = ShoppingCart()
cart.addItem(product: laptop, quantity: 1)
cart.addItem(product: book, quantity: 2)

// Add same product again -> quantity increases
cart.addItem(product: laptop, quantity: 1) // теперь ноутбуков 2

print("Subtotal:", cart.subtotal)
print("Item count:", cart.itemCount)

// Discount code
cart.discountCode = "SAVE10"
print("Total with discount:", cart.total)

// Remove
cart.removeItem(productId: book.id)

// Reference semantics demo
func modifyCart(_ c: ShoppingCart) {
    c.addItem(product: headphones, quantity: 1)
}
modifyCart(cart) // изменит тот же экземпляр
print("After modifyCart(), item count:", cart.itemCount)

// Value semantics demo
let item1 = CartItem(product: laptop, quantity: 1)
var item2 = item1
item2.updateQuantity(5)
print("item1.quantity:", item1.quantity) // 1
print("item2.quantity:", item2.quantity) // 5

// Create order (snapshot)
let addr = Address(street: "Satpayev 22", city: "Almaty", zipCode: "050000", country: "Kazakhstan")
let order = Order(from: cart, shippingAddress: addr)

// Change cart after order created
cart.clearCart()

print("Order items count:", order.itemCount) // не 0
print("Cart items count:", cart.itemCount)   // 0
print("Order address:\n\(order.shippingAddress.formattedAddress)")
