use Oishi;


exec AddAdmin @login = 'Admin', @pass = '1234', @role = 'administrator';


exec InsertIntoDishtypes @dishtypename='Лапша';
exec InsertIntoDishtypes @dishtypename='Рамэн';
exec InsertIntoDishtypes @dishtypename='Рис';
exec InsertIntoDishtypes @dishtypename='Суп';
exec InsertIntoDishtypes @dishtypename='Донбури';
exec InsertIntoDishtypes @dishtypename='Поке';


exec InsertIntoMenu @name = 'Фунчоза с цыплёнком-гриль', @price = 13.52, @weight = 420, @typename = 'Лапша', @desc = 'Рисовая лапша в пекинском соусе, цыпленок-гриль, пекинская капуста, морковь, спаржевая фасоль, сладкий перец, яйцо, лук-порей, кунжут. Острое.';
exec InsertIntoMenu @name = 'Фунчоза с тигровыми креветками', @price = 20.90, @weight = 420, @typename = 'Лапша', @desc = 'Рисовая лапша в кисло-сладком соусе, креветка, пекинская капуста, морковь, спаржевая фасоль, сладкий перец, ананас, яйцо, кунжут, лук-порей, арахис.';
exec InsertIntoMenu @name = 'Фунчоза с морепродуктами', @price = 19.90, @weight = 420, @typename = 'Лапша', @desc = 'Рисовая лапша в соусе Жгучий Хакусан, кольца кальмара, осьминоги, пекинская капуста, морковь, спаржевая фасоль, сладкий перец, грибы шиитаке, яйцо, лайм, лук-порей, стружка тунца.';
exec InsertIntoMenu @name = 'Фунчоза с говядиной', @price = 19.90, @weight = 420, @typename = 'Лапша', @desc = 'Рисовая лапша в соусе Карри, ростбиф, пекинская капуста, морковь, спаржевая фасоль, сладкий перец, такуан, яйцо, лук-порей, арахис. Острое.';
exec InsertIntoMenu @name = 'Якисоба с цыпленком-гриль', @price = 14.90, @weight = 420, @typename = 'Лапша', @desc = 'Пшеничная лапша в кисло-сладком соусе, цыпленок-гриль, пекинская капуста, морковь, спаржевая фасоль, сладкий перец, ананас, яйцо, лук-порей, нори.';
exec InsertIntoMenu @name = 'Якисоба со свининой Чашу', @price = 17.90, @weight = 420, @typename = 'Лапша', @desc = 'Пшеничная лапша в соусе Яки, свинина Чашу, пекинская капуста, морковь, спаржевая фасоль, сладкий перец, шампиньоны, ростки сои, яйцо, лук-порей, стружка тунца.';
exec InsertIntoMenu @name = 'Удон с цыпленком-гриль', @price = 15.90, @weight = 420, @typename = 'Лапша', @desc = 'Удон в соусе Карри, цыпленок-гриль, пекинская капуста, морковь, спаржевая фасоль, сладкий перец, такуан, яйцо, перец чили, лук-порей, кунжут. Острое.';
exec InsertIntoMenu @name = 'Удон с филе индейки', @price = 15.90, @weight = 420, @typename = 'Лапша', @desc = 'Удон в пекинском соусе, индейка, пекинская капуста, морковь, спаржевая фасоль, сладкий перец, яйцо, лук-порей, кунжут. Острое.';
exec InsertIntoMenu @name = 'Рамэн Кимчи с ростбифом', @price = 17.90, @weight = 570, @typename = 'Рамэн', @desc = 'Мясной бульон, соус Кимчи, фунчоза, ростбиф, морковь, такуан, яйцо, ростки сои, салат Ромен, перец чили, мята. Острое.';
exec InsertIntoMenu @name = 'Рамэн с тремя видами грибов', @price = 10.90, @weight = 570, @typename = 'Рамэн', @desc = 'Овощной бульон, паста мисо, пшеничная лапша, томатный соус, древесные грибы, шампиньоны, грибы шиитаке, морковь, омлет Тамаго, томаты черри, салат Ромен.';
exec InsertIntoMenu @name = 'Тяхан с цыпленком-гриль', @price = 12.90, @weight = 360, @typename = 'Рис', @desc = 'Японский рис, обжаренный в кунжутном масле с яйцом и соусом Терияки, цыпленок-гриль, сладкий перец, кунжут, репчатый лук и лук-порей.';
exec InsertIntoMenu @name = 'Тяхан с говядиной в соусе Карри', @price = 15.90, @weight = 360, @typename = 'Рис', @desc = 'Японский рис, обжаренный в кунжутном масле с яйцом и соусом Карри, ростбиф, морковь, зеленый горошек, репчатый лук, кунжут, перец чили, лук-порей. Острое.';
exec InsertIntoMenu @name = 'Том Ям с креветками', @price = 16.90, @weight = 420, @typename = 'Суп', @desc = 'Куриный бульон, кокосовое молоко, сливки, креветка, кольца кальмара, грибами шиитаке, такуан, перец чили, кинза, лайм, онигири. Острое.';
exec InsertIntoMenu @name = 'Мисо суп', @price = 7.90, @weight = 350, @typename = 'Суп', @desc = 'Паста мисо, древесные грибы, соевая спаржа, соевый сыр Тофу, водоросли вакамэ, лук-порей, онигири.';
exec InsertIntoMenu @name = 'Поке Боул с креветкой', @price = 24.90, @weight = 300, @typename = 'Поке', @desc = 'Японский рис, креветка, манго, рукола, томаты черри, авокадо, лайм, соус чили сладкий, соус сладко-ореховый.';
exec InsertIntoMenu @name = 'Поке Боул с лососем и кокосовым рисом', @price = 23.90, @weight = 330, @typename = 'Поке', @desc = 'Японский рис, лосось, авокадо, огурец, салат чука, томаты черри, нори, кокосовое молоко, соевый соус, масло кунжутное.';
exec InsertIntoMenu @name = 'Донбури со свининой Чашу', @price = 18.90, @weight = 350, @typename = 'Донбури', @desc = 'Японский рис, свинина Чашу, соус Яки, томаты черри, ростки сои, морковь, салат Ромен, лук-порей.';
exec InsertIntoMenu @name = 'Донбури с цыпленком-гриль', @price = 13.90, @weight = 340, @typename = 'Донбури', @desc = 'Японский рис, цыпленок-гриль, соус Терияки, морковь, свежий огурец, омлет Тамаго, кунжут, лук-порей.';					


exec InsertIntoRestables @number = 1, @desc = 'Столик на 4 персоны у окна.';
exec InsertIntoRestables @number = 2, @desc = 'Столик на 2 персоны у окна.';
exec InsertIntoRestables @number = 3, @desc = 'Столик на 6 персон у стены.';
exec InsertIntoRestables @number = 4, @desc = 'Столик на 8 персон у окна.';
exec InsertIntoRestables @number = 5, @desc = 'Столик на 8 персон у стены.';
exec InsertIntoRestables @number = 6, @desc = 'Столик на 4 персоны на среднем ряду.';
exec InsertIntoRestables @number = 7, @desc = 'Столик на 12 персон на среднем ряду.';
exec InsertIntoRestables @number = 8, @desc = 'Столик на 2 персоны у окна.';
exec InsertIntoRestables @number = 9, @desc = 'Столик на 2 персоны у стены.';
exec InsertIntoRestables @number = 10, @desc = 'Столик на 4 персоны у окна.';
exec InsertIntoRestables @number = 11, @desc = 'Столик на 2 персоны на среднем ряду.';
exec InsertIntoRestables @number = 12, @desc = 'Столик на 10 персон у стены.';
exec InsertIntoRestables @number = 13, @desc = 'Столик на 1 персоны у стены.';
exec InsertIntoRestables @number = 14, @desc = 'Столик на 2 персоны у окна.';
exec InsertIntoRestables @number = 15, @desc = 'Столик на 2 персоны у стены.';


exec MakeOrder @login = 'Ksu', @datetime = '20220518 16:30:00', @tablenum = 2, @email = 'budanowa.ksenia@gmail.com', @wishes = 'Maybe table 2';


exec AddReview @login = 'Ksu', @text = 'Отличное заведение с приемлимыми ценами и приятным обслуживанием!';

		
