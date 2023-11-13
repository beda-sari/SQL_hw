--86. a.Bu ülkeler hangileri..?
select distinct country from customers

--87. En Pahalı 5 ürün
select product_name,unit_price from products 
order by unit_price desc
limit 5

--88.ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?	 
select customer_id, SUM(quantity) from orders o
inner join order_details od on od.order_id =o.order_id
where customer_id= 'ALFKI'
group by customer_id

--89.Ürünlerimin toplam maliyeti
select sum((units_on_order+units_in_stock)*unit_price)
from products

--90.Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select SUM((unit_price*quantity)*(1-discount)) as ciro
from order_details

--91.Ortalama Ürün Fiyatım
select AVG(unit_price) from products

--92.En Pahalı Ürünün Adı
select product_name, unit_price from products
order by unit_price DESC
limit 1

--93.En az kazandıran sipariş
select order_id,sum((unit_price*quantity)*(1-discount)) as kazanc 
from order_details
group by order_id
order by kazanc asc
limit 1
--2.yol
select order_id,sum(unit_price*quantity) as dusuk_kazanc
from order_details
group by order_id
order by dusuk_kazanc asc
limit 1

--94.Müşterilerimin içinde en uzun isimli müşteri
select company_name from customers
group by company_name
order by max(length(company_name)) desc
limit 1
--2.yol
select max(length(company_name)) AS maxuzunluk
from customers
--3.yol
select company_name,LENGTH(company_name) from customers 
GROUP BY company_name 
order by MAX(LENGTH(company_name)) desc
Limit 1

--95.Çalışanlarımın Ad, Soyad ve Yaşları
--1.yol
select first_name,last_name,extract(year from age(current_date,birth_date)) from employees
--2.yol
select first_name, last_name, DATE_PART('year', AGE(current_date, birth_date)) as age 
from employees

--96.Hangi üründen toplam kaç adet alınmış..?
select p.product_name,sum(od.quantity) as total_quantity from products p 
inner join order_details od on p.product_id=od.product_id
group by p.product_name
order by total_quantity desc

--97.Hangi siparişte toplam ne kadar kazanmışım..?
select order_id,sum(unit_price*quantity) from order_details
group by order_id
order by order_id asc

--98.Hangi kategoride toplam kaç adet ürün bulunuyor..?
--sinem çözümü
select category_name,sum(product_id) as total_products from products p 
inner join categories c on p.category_id=c.category_id
group by c.category_name
order by total_products desc
--betül çözüm
select category_id, count(category_id) as toplam_urun
from products
group by category_id

select category_name,count(product_name) from categories c
inner join products p on p.category_id=c.category_id
group by category_name

select c.category_name, sum(p.category_id) as adet from categories c
inner join products p on p.category_id = c.category_id
group by c.category_name 
order by c.category_name asc

--99.1000 Adetten fazla satılan ürünler?
select p.product_name, sum(od.quantity) as total_quantity from Products p
inner join Order_Details od on p.product_id = od.product_id
group by p.product_name
having sum(od.quantity) > 1000
order by total_quantity desc;
			 
--100.Hangi Müşterilerim hiç sipariş vermemiş..?		 
select c.company_name,c.customer_id, o.order_id from customers c
left join orders o on o.customer_id = c.customer_id
where o.order_id is null
			 	 
--101.Hangi tedarikçi hangi ürünü sağlıyor ?
select company_name,product_name from suppliers s
inner join products p on s.supplier_id=p.supplier_id
ORDER BY s.company_name, p.product_name

--102.Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?**
select o.order_id,s.company_name,o.shipped_date
from orders o
inner join shippers s on s.shipper_id=o.ship_via

--103.Hangi siparişi hangi müşteri verir..?
select order_id,company_name from orders o
inner join customers c on o.customer_id=c.customer_id
group by order_id,company_name
order by order_id asc

select o.order_id,c.customer_id,c.company_name
from orders o
inner join customers c on o.customer_id=c.customer_id

--104.Hangi çalışan, toplam kaç sipariş almış..?
select first_name,last_name,count(order_id) as total_orders from employees e
inner join orders o on e.employee_id=o.employee_id
group by first_name,last_name
order by total_orders desc

--105.En fazla siparişi kim almış..?
select first_name,last_name,count(o.order_id)as most_ordered from employees e  
inner join orders o on e.employee_id=o.employee_id
group by first_name,last_name
order by most_ordered desc 
limit 1

--106.Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?**
select order_id,concat(first_name,' ',last_name),company_name from orders o
inner join employees e on o.employee_id=e.employee_id
inner join customers c on o.customer_id=c.customer_id
group by order_id,first_name,last_name,company_name
order by order_id asc

--107.Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
select product_name,category_name,company_name from products p
inner join categories c on p.category_id=c.category_id
inner join suppliers s on p.supplier_id=s.supplier_id
order by product_name asc

--108.Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, 
--hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış, 
--ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
select o.order_id,c.company_name,concat(first_name,' ',last_name),o.order_date,od.quantity,p.unit_price,ca.category_name,s.company_name 
from orders o
inner join customers c on o.customer_id=c.customer_id
inner join employees e on o.employee_id=e.employee_id
inner join order_details od on o.order_id=od.order_id
inner join products p on od.product_id=p.product_id
inner join suppliers s on p.supplier_id=s.supplier_id
inner join categories ca on p.category_id=ca.category_id

--109.Altında ürün bulunmayan kategoriler
SELECT c.category_name,p.product_name FROM products p
RIGHT JOIN categories  c ON p.category_id=c.category_id
WHERE product_name IS NULL
			 
--110.Manager ünvanına sahip tüm müşterileri listeleyiniz.
select *from customers
where contact_title like '%Manager%'

--111.FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
SELECT customer_id
FROM customers
WHERE customer_id LIKE 'FR___'

--112.(171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select *from customers
where phone like '(171)%'

--113.BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
select *from products
where quantity_per_unit like '%boxes%'

--114.Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
select contact_name,contact_name,contact_title,country,phone from customers
where country in ('France','Germany') and contact_title like '%Manager%'

--115.En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
select *from products
order by unit_price desc
limit 10

--116.Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
select company_name,country,city from customers
order by country asc,city desc

--117.Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
select first_name,last_name,extract(year from age(birth_date)) from employees

--118.35 gün içinde sevk edilmeyen satışları listeleyiniz.
--1.yöntem
select order_id , customer_id , order_date, shipped_date
from orders 
where shipped_date is null and (current_date - order_date) > 35

--2.yöntem
SELECT * 
FROM orders
WHERE shipped_date - order_date > 35

--119.Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select category_name from categories
where exists (select max(unit_price) from products
			 where categories.category_id=products.category_id
			)
			limit 1
			
--2.yöntem			
select category_name
from categories
where category_id in (select category_id from products where unit_price = 
                     (select max(unit_price) from products))
			
--120.Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)***
select category_name from categories
where category_name like '%on%'

--2.yöntem
select category_name
from categories
where category_id in (select category_id from categories where category_name like '%on%')

--121.Konbu adlı üründen kaç adet satılmzıştır.
select sum(quantity) from order_details od
inner join products p on od.product_id=p.product_id
where product_name='Konbu'
	 
--122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select count(distinct(p.product_id)) from products p
where exists(select *from suppliers s
			 where p.supplier_id=s.supplier_id
			and s.country='Japan'
			)
			
--123.1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
SELECT MAX(freight) AS maksimum, MIN(freight) AS minimum, AVG(freight) as average
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 1997

--124.Faks numarası olan tüm müşterileri listeleyiniz.
select *from customers
where fax is not null

--125.1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
select *from orders
where shipped_date between '1996-07-16'and'1996-07-30'