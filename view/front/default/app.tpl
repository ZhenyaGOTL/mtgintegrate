<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="color-scheme" content="light dark">

        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">
        <script src="https://telegram.org/js/telegram-web-app.js"></script>

        <script>
            let tg = window.Telegram.WebApp;
            if (tg.colorScheme=='light'){
                var colorScheme = '<meta name="color-scheme" content="light"><link href="/modules/mtgintegrate/view/front/default/css/bootstrap.min.css" rel="stylesheet">';
                var colorSchemeBG = '<meta name="theme-color" content="#111111" media="(prefers-color-scheme: light)">';
                var colorSchemeNav = 'bg-light';
            }else{
                var colorScheme = '<meta name="color-scheme" content="dark"><link href="/modules/mtgintegrate/view/front/default/css/bootstrap-dark.min.css" rel="stylesheet">';
                var colorSchemeBG =  '<meta name="theme-color" content="#eeeeee" media="(prefers-color-scheme: dark)">';
                var colorSchemeNav = 'bg-dark';
            }
            function echo (theline) {
                return document.write(theline);
            }
            echo (colorSchemeBG);
            echo (colorScheme);
            window.onload = function(){

                document.getElementById('navbar').classList.add(colorSchemeNav);
            }
            tg.MainButton.text = '🛒 Корзина'
        </script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@2.6.0"></script>
    </head>
<body>
<div id="app"> 
    <header v-show="header_show" id="navbar" class="navbar navbar-expand-lg navbar-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="#" @click="mainpage()">
                <img src="{$logo.__logo_inverse->getUrl(238, 238)}" alt="" height="40" v-if="logo_inverse!=''&&tg.colorScheme!='light'">
                <img src="{$logo.__logo->getUrl(238, 238)}" alt="" height="40" v-else-if="logo_default!=''">
                <img alt="" v-else>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    {foreach $categories[0] as $category}
                        {if (isset($categories[$category->id]))}                       
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="{$category->id}" role="button" data-bs-toggle="dropdown" aria-expanded="false" @click="categories">
                                {$category->name}
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="{$category->id}">
                                {foreach $categories[$category->id] as $cat}
                                    {if isset($categories[$cat->id])}
                                        <li>
                                            <a class="dropdown-item" id="{$cat->id}" @click="subcategories">{$cat->name}</a>
                                            <ul class="{$cat->id}">
                                                {foreach $categories[$cat->id] as $down}
                                                    <li><a id="{$down->id}" class="dropdown-item category" @click="categories_page" href="#" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent">{$down->name}</a></li>
                                                {/foreach}
                                            </ul>
                                        </li>
                                        <li><hr class="dropdown-divider"></li>
                                    {else}
                                        <li><a class="dropdown-item" id="{$cat->id}" @click="categories_page" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent">{$cat->name}</a></li>
                                    {/if}
                                {/foreach}
                            </ul>
                        </li>
                        {else}
                        <li class="nav-item">
                            <a class="nav-link" id="{$category->id}" @click="categories_page" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent">{$category->name}</a>
                        </li>
                        {/if}
                    {/foreach}
                </ul>
            </div>
        </div>
    </header>

    <main>
        <div v-show="offers_show">
            <h1>Комплектации</h1>
            <select v-model="offer_id" v-if="offers.length!=0&&multioffers.length==0" @change="change_offer()">
            <option v-for="offer in offers" :value="offer.id">%% offer.title %%
            </select>
            <div v-for="(multioffer) in multioffers" v-else-if="multioffers.length!=0">
                <select :name="multioffer.prop_id" @change="change_price()" v-model="multioffers_selected[multioffer.title]">
                <option v-for="value in multioffer.values" :value="value.value">%% value.value %%</option>
                </select>
            </div>
            <div v-else>
            </div>
            <p>%% offer_price!=''? 'Цена: '+offer_price : 'Данная комплектация не возможна' %%</p>
            <button @click="add_offers()" v-show="offer_price!=''">Добавить в корзину</button>
        </div>
        <div class="container content-space-1">
            <div v-if="page == 'category'">
                <div v-if="products != null">
                    <div v-for="product in products" class="card mb-1">
                        <img class="card-img-top" :src="'/storage/photo/original/'+product.image" alt="%% product.title %%">
                        <div class="card-body">
                            <h3 class="card-title">%% product.title %%</h3>
                            <p>%% product.short_description %%</p>
                            <div class="d-flex">
                                <div class="flex-shrink-0">
                                    <span class="display-4 lh-1">%% product.cost %%</span>
                                </div>
                                <div class="flex-grow-1 align-self-end ms-3">
                                    <span class="d-block">%% product.currency %%</span>
                                </div>
                                <div class="d-grid gap-2">
                                    <button @click="add_cart(product.id)" class="btn btn-primary" type="button"><i class="bi bi-bag"></i> В корзину</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div v-else>
                    <h3>В данной категории нет товаров</h3>
                </div>
            </div>
            <div v-else-if="page == 'cart'">
                <div class="row">
                    <div class="col-md-12">
                        <div class="mt-3 mb-3">
                          <h2>Корзина</h2>
                        </div>
                        <ol class="list-group list-group-numbered">
                            <li v-for="product_cart in products_cart" class="list-group-item d-flex justify-content-between align-items-start">
                                <div class="ms-2 me-auto">
                                    <div class="fw-bold">%% product_cart.title %%</div>
                                    %% product_cart.short_description %%
                                    <div class="d-flex">
                                        <div class="flex-shrink-0">
                                            <span class="display-4 lh-1">%% product_cart.single_cost %%</span>
                                        </div>
                                        <div class="flex-grow-1 align-self-end ms-3">
                                            <span class="d-block">x %% product_cart.amount %%</span>
                                        </div>
                                        <div class="flex-shrink-0">
                                            <span class="display-4 lh-1">= %% product_cart.cost %%</span>
                                        </div>
                                    </div>
                                    <div class="d-grid gap-2">
                                        <input type="range" class="form-range" min="1" :max="product_cart.num" :id="product_cart.entity_id" :value="product_cart.amount" name="quant[%% product_cart.id %%]"  @change="change_amount">
                                    </div>
                                </div>
                                <span class="badge">
                                    <button type="button" class="btn btn-danger btn-sm" @click="remove_product(product_cart.id)">
                                        <i class="bi bi-trash" @click="remove_product(product_cart.id)"></i>
                                    </button>
                                </span>
                                <p>%% product_cart.hasOwnProperty('offer_title')? 'Комплектация: '+product_cart.offer_title : 'Комплектация: стандартная' %%</p>
                            </li>
                        </ol>
                    </div>
                    <div class="col-md-12">
                        <div class="mt-3 mb-3">
                            <h4>Итого: %% total %%</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div v-else-if="page == 'design'">
                <div v-if="design_step==0">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="mt-3 mb-3">
                                <h2>Выберите способ доставки</h2>
                            </div>
                            <form>
                                <div class="mb-3">
                                    <input type="radio" name="delivery_type" value="0" id="option1" checked v-model="delivery_type" class="btn-check">
                                    <label class="btn btn-secondary" for="option1">Самовывоз</label>

                                    <input type="radio" name="delivery_type" value="1" id="option2" v-model="delivery_type" class="btn-check">
                                    <label class="btn btn-secondary" for="option2">Доставка</label>
                                </div>
                                <div v-if="delivery_type==1">
                                    <div class="mb-3">
                                        <label for="country" class="form-label">Страна</label>
                                        <select @change="country_change" v-model="country_id" class="form-control" id="country">
                                            <option value="0">Не выбрано</option>
                                            <option v-for="country in countries" :value="country.id">%% country.title %%</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="region" class="form-label">Область/Регион</label>
                                        <select @change="region_change" v-model="region_id" class="form-control" id="region" v-if="regions_show.length!=0">
                                            <option value="0">Не выбрано</option>
                                            <option v-for="region in regions_show" :value="region.id">%% region.title %%</option>
                                        </select>
                                        <input type="text" placeholder="Введите регион" id="region" v-model="region_name" class="form-control" v-else>
                                    </div>
                                    <div class="mb-3">
                                        <label for="city" class="form-label">Город</label>
                                        <select v-model="city_id" class="form-control" id="city" v-if="cities_show.length!=0">
                                            <option value="0">Не выбрано</option>
                                            <option v-for="city in cities_show" :value="city.id">%% city.title %%</option>
                                        </select>
                                        <input type="text" placeholder="Введите город" id="city" class="form-control" v-model="city_name" v-else>
                                    </div>
                                    <div class="mb-3">
                                        <label for="address" class="form-label">Ваш адрес</label>
                                        <input type="text" name="address" placeholder="Введите адрес" v-model="address" class="form-control" id="address">
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="fio" class="form-label">ФИО</label>
                                    <input type="text" v-model="fio" placeholder="Введите ФИО" class="form-control" id="fio">
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Электронная почта</label>
                                    <input type="email" v-model="email" placeholder="Введите электронную почту" class="form-control" id="email">
                                    <p>Нужно указать почту, чтобы получать уведомления</p>
                                </div>
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Контактный телефон</label>
                                    <input type="phone" v-model="phone" placeholder="Введите номер телефона" class="form-control" id="phone">
                                </div>
                                <button @click="next()" class="btn btn-primary">Далее</button>
                            </form>
                        </div>
                    </div>
                </div>
                <div v-else-if="design_step==1">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="mt-3 mb-3">
                                <h2>Выберите способ доставки</h2>
                            </div>
                            <form>
                                <div class="list-group">
                                    <label v-for="del in delivery" class="list-group-item">
                                        <input type="radio" :value="del.id" v-model="delivery_type" :id="del.id" >
                                        <div class="d-flex w-100 justify-content-between">
                                            <h5 class="mb-1">%% del.title %%</h5>
                                            <small>%% del.cost %%</small>
                                        </div>
                                        <p class="mb-1">Some placeholder content in a paragraph.</p>
                                    </label>
                                    <div class="mt-3 mb-3">
                                        <button @click="next2()" class="btn btn-primary">Далее</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div v-else-if="design_step==2">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="mt-3 mb-3">
                                <h2>Выберите способ оплаты</h2>
                            </div>
                            <form>
                                <div class="list-group">
                                    <label v-for="payment in payments" class="list-group-item">
                                        <input type="radio" v-model="payment_id" :value="payment.id" :id="payment.id">
                                        %% payment.title %%
                                    </label>
                                </div>
                                <div class="mt-3 mb-3">
                                    <button @click="checkout()" class="btn btn-primary">Далее</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div v-else>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="mt-3 mb-3">
                                <h2>Заказ успешно оформлен</h2>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div v-else>
				{if (!empty($zone))}
					{if (!empty($banners))}
					<div id="carouselExampleIndicators" class="carousel slide mb-2" data-bs-ride="carousel">
						{$i=0}
						<div class="carousel-indicators">
							{$i=0}
							{foreach $banners as $banner}
								{if ($i==0)}
								<button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="{$i}" class="active" aria-current="true" aria-label="12"></button>
								{else}
								<button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="{$i}" aria-current="true" aria-label="12"></button>
								{/if}
								{$i=$i+1}
							{/foreach}
						</div>
						<div class="carousel-inner">
							{$i=0}
							{foreach $banners as $banner}
								{if ($i==0)}
								<div class="carousel-item active"><img src="{$banner->getBannerUrl($zone.width, $zone.height)}" alt="{$banner.title}" class="img-fluid rounded"></div>
								{else}
								<div class="carousel-item"><img src="{$banner->getBannerUrl($zone.width, $zone.height)}" alt="{$banner.title}" class="img-fluid rounded"></div>
								{/if}
								{$i=$i+1}
							{/foreach}
						</div>
						<button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
							<span class="carousel-control-prev-icon" aria-hidden="true"></span>
							<span class="visually-hidden">Previous</span>
						</button>
						<button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
							<span class="carousel-control-next-icon" aria-hidden="true"></span>
							<span class="visually-hidden">Next</span>
						</button>
					</div>
					{/if}
				{/if}
                {if ($cat == true && !empty($products))}
				<div class="row">
                    {foreach $products as $product}
					<div class="col-6">
						<div class="card mb-1">
							<img class="card-img-top" src="/storage/photo/original/{$product->image}" alt="{$product->title}">
							<div class="card-body">
								<h3 class="card-title">{$product->title}</h3>
								<p>{$product->short_description}</p>
								<div class="">
									<div class="">
										<span class="display-4 lh-1">{$product->cost}</span>
									</div>
									<div class="">
										<span class="d-block">{$product->currency}</span>
									</div>
									<div class="">
										<button @click="add_cart({$product->id})" class="btn btn-primary" type="button"><i class="bi bi-bag"></i> В корзину</button>
									</div>
								</div>
							</div>
						</div>
					</div>
                    {/foreach}
				</div>
                {/if}
                </div>
            </div>
        </div>
    </main>
</div>
<script src="/modules/mtgintegrate/view/front/default/js/bootstrap.bundle.min.js"></script>

<script>
let app = new Vue({
    delimiters: ['%%', '%%'],
    el: '#app',
    data: {
        user_tg: tg.initDataUnsafe.user,
        page: '',
        category_id: 0,
        subcategory_id: 0,
        products: [],
        products_cart: [],
        total: 0,
        design_step: 0,
        delivery_type: 0,
        countries: [],
        regions: [],
        cities: [],
        regions_show: [],
        cities_show: [],
        address: '',
        country_id: 0,
        region_id: 0,
        city_id: 0,
        delivery: [],
        payment_id: 0,
        payments: [],
        telegram: tg,
        phone: '',
        header_show: true,
        email: '@'+tg.initDataUnsafe.user.username,
        fio: tg.initDataUnsafe.user.first_name,
        logo_default: '{(isset($logo->logo))?$logo->logo:null}',
        logo_inverse: '{(isset($logo->logo_inverse))?$logo->logo_inverse:null}',
        city_name: '',
        region_name: '',
        offers_show: false,
        offers: [],
        multioffers: [],
        prod_id: 0,
        offer_id: 0,
        multioffers_selected: {},
        offer_price: '',
    },
    methods:{
        categories(event){
            if (this.category_id!=event.target.id){
                this.category_id=event.target.id
            }else{
                this.category_id=0
            }
        },
        subcategories(event){
            if (this.subcategory_id!=event.target.id){
                this.subcategory_id=event.target.id
            }else{
                this.subcategory_id=0
            }
        },
        categories_page(event){
            $.ajax({
                url: '/api{$key}/methods/products.get?category_id='+event.target.id+'&type={$prod}'
            }).done((e)=>{
                if (e.response.products!=null){
                for (let i = 0; i<e.response.products.length; i++){
                    e.response.products[i].title = e.response.products[i].title.replaceAll("&amp;", '&')
                    e.response.products[i].title = e.response.products[i].title.replaceAll("&gt;",'>')
                    e.response.products[i].title = e.response.products[i].title.replaceAll("&lt;",'<')
                    e.response.products[i].title = e.response.products[i].title.replaceAll("&quot;",'"')
                }
                }
                this.products = e.response.products
                return
            })
            this.page = 'category'
        },
        add_cart(product_id){
            $.ajax({
                url: '/api{$key}/methods/product.getofferslist?product_id='+product_id
            }).done((off)=>{
                if (off.response.offers.length>1&&!off.response.hasOwnProperty('multioffers')){
                    this.offers = off.response.offers
                    this.offers_show = true
                    this.prod_id = product_id
                    return
                }
                if (off.response.hasOwnProperty('multioffers')){
                    this.multioffers = off.response.multioffers
                    this.offers_show = true
                    this.prod_id = product_id
                    this.offers = off.response.offers
                    return
                }
            $.ajax({
                url: '/api{$key}/methods/cart.add?id='+product_id,
            }).done((e)=>{
                for (let i = 0; i<e.response.cartdata.items.length; i++){
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&amp;", '&')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&gt;",'>')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&lt;",'<')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&quot;",'"')
                }
                this.products_cart = e.response.cartdata.items
                this.total = e.response.cartdata.total
                for (let i = 0; i<app.products_cart.length; i++){
                $.ajax({
                    url: '/api{$key}/methods/products.get_description?product_id='+app.products_cart[i].entity_id,
                }).done((res)=>{
                    app.products_cart[i].short_description = res.response.product
                    return
                })
                $.ajax({
                    url: '/api{$key}/methods/products.get_num?product_id='+app.products_cart[i].entity_id,
                }).done((res)=>{
                if (parseInt(res.response.num)>100){
                    app.products_cart[i].num = 100
                }else{
                    app.products_cart[i].num = parseInt(res.response.num)
                }
                    return
                })
                if (app.products_cart[i].type=="offers"){
                     $.ajax({
                        url: '/api{$key}/methods/product.getofferslist?product_id='+app.products_cart[i].entity_id,
                    }).done((off)=>{
                        for (var j = 0; j<off.response.offers.length;j++){
                            if (off.response.offers[j].id==app.products_cart[i].offer){
                                app.products_cart[i].offer.title = off.response.offers[j].title
                            }
                        }
                        return
                    })
                }
                }
                return
            })
            tg.MainButton.text = '🛒 Корзина'
            this.telegram.MainButton.show()
            })
        },
        add_offers(){
            if (this.offer_id!=0){
                $.ajax({
                url: '/api{$key}/methods/cart.add?id='+this.prod_id+'&offer_id='+this.offer_id,
            }).done((e)=>{
                this.offers_show = false
                this.product_id=0
                this.offer_id=0
                this.offer_price = 0
                this.offers = []
                this.multioffers = []
                this.multioffers_selected = []
                console.log(e)
                for (let i = 0; i<e.response.cartdata.items.length; i++){
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&amp;", '&')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&gt;",'>')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&lt;",'<')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&quot;",'"')
                }
                this.products_cart = e.response.cartdata.items
                this.total = e.response.cartdata.total
                for (let i = 0; i<app.products_cart.length; i++){
                $.ajax({
                    url: '/api{$key}/methods/products.get_description?product_id='+app.products_cart[i].entity_id,
                }).done((res)=>{
                    app.products_cart[i].short_description = res.response.product
                })
                $.ajax({
                    url: '/api{$key}/methods/products.get_num?product_id='+app.products_cart[i].entity_id,
                    async: false,
                }).done((res)=>{
                if (parseInt(res.response.num)>100){
                    app.products_cart[i].num = 100
                }else{
                    app.products_cart[i].num = parseInt(res.response.num)
                }
                })
                if (app.products_cart[i].type=="offers"){
                     $.ajax({
                        url: '/api{$key}/methods/product.getofferslist?product_id='+app.products_cart[i].entity_id,
                        async: false,
                    }).done((off)=>{
                        for (var j = 0; j<off.response.offers.length;j++){
                            if (off.response.offers[j].id==app.products_cart[i].offer){
                                app.products_cart[i].offer_title = off.response.offers[j].title
                            }
                        }
                    })
                }
                }
                return
            })
            tg.MainButton.text = '🛒 Корзина'
            this.telegram.MainButton.show()
            }
        },
        change_amount(event){
            $.ajax({
                url: '/api{$key}/methods/cart.changeamount?id='+event.target.id+'&amount='+event.target.value
            }).done((e)=>{
                for (let i = 0; i<e.response.cartdata.items.length; i++){
                    this.products_cart[i].amount = e.response.cartdata.items[i].amount
                }
                this.total = e.response.cartdata.total
                return
            })
        },
        country_change(event){
            $.ajax({
                url: '/api{$key}/methods/checkout.getaddresslistsinfo?sections[]=regions'
            }).done((e)=>{
                app.regions = e.response.lists.regions
                this.regions_show = []
                for (let i = 0; i<this.regions.length;i++){
                    if (this.regions[i].parent_id==event.target.value){
                        this.regions_show.push(this.regions[i])
                    }
                }
                this.cities_show = []
                return
            })
        },
        region_change(event){
            $.ajax({
                url: '/api{$key}/methods/checkout.getaddresslistsinfo?sections[]=city'
            }).done((e)=>{
                app.cities = e.response.lists.city
                this.cities_show = []
                for (let i = 0; i<this.cities.length;i++){
                    if (this.cities[i].parent_id==event.target.value){
                        this.cities_show.push(this.cities[i])
                    }
                }
                return
            })
        },
        next(){
            if (this.delivery_type==1){
            if (this.country_id==0){
                alert('Вы не выбрали страну')
                return
            }
            if (this.region_id==0&&this.region_name==''){
                alert('Вы не выбрали регион')
                return
            }
            if (this.city_id==0&&this.city_name==''){
                alert('Вы не выбрали город')
                return
            }
            if (this.address==''){
                alert('Вы не ввели адрес')
                return
            }
            if (this.phone==''){
                alert('Вы не ввели телефон')
                return
            }
            this.delivery = []
            let country_name = ''
            let zipcode = ''
            for (let i = 0; i<this.countries.length;i++){
                if (this.countries[i].id==this.country_id){
                    country_name = this.countries[i].title
                }
            }
            if (this.region_id!=0&&this.city_id!=0){
            let region_name = ''
            let city_name = ''
            for (i = 0; i<this.regions.length;i++){
                if (this.regions[i].id==this.region_id){
                    region_name = this.regions[i].title
                }
            }
            for (i = 0; i<this.cities.length;i++){
                if (this.cities[i].id==this.city_id){
                    city_name = this.cities[i].title
                    zipcode = this.cities[i].zipcode
                }
            }
            $.ajax({
                url: '/api{$key}/methods/checkout.setaddress?city_id='+this.city_id+'&city='+city_name+'&country_id='+this.country_id+'&country='+country_name+'&region_id='+this.region_id+'&region='+region_name+'&address='+this.address+'&zipcode='+zipcode
            }).done((e)=>{
                for (i = 0;i<e.response.delivery.list.length;i++){
                    if (e.response.delivery.list[i].title!='Самовывоз'){
                        this.delivery.push(e.response.delivery.list[i])
                    }
                }
                return
            })
            }else{
                $.ajax({
                url: '/api{$key}/methods/checkout.setaddress?city='+this.city_name+'&country_id='+this.country_id+'&country='+country_name+'&region='+this.region_name+'&address='+this.address
            }).done((e)=>{
                for (i = 0;i<e.response.delivery.list.length;i++){
                    if (e.response.delivery.list[i].title!='Самовывоз'){
                        this.delivery.push(e.response.delivery.list[i])
                    }
                }
                return
            })
            }
            
            this.design_step = 1
            }else{
                if (this.phone==''){
                alert('Вы не ввели телефон')
                return
                }
                $.ajax({
                    url: '/api{$key}/methods/checkout.setdelivery?delivery_id=1'
                }).done((e)=>{
                    return
                })
                $.ajax({
                    url: '/api{$key}/methods/payment.getlist'
                }).done((e)=>{
                    this.payments = e.response.list
                    return
                })
                this.design_step = 2
            }
            this.delivery_type=null
            user = {
                'user':{
                    'user_fio':this.fio,
                    'user_email':this.email,
                    'user_phone':this.phone
                }
            }
            $.ajax({
                url: '/api{$key}/methods/checkout.address',
                contentType: 'application/json',
                data: user
            }).done((e)=>{
                return
            })
        },
        next2(){
                if (this.delivery_type==null){
                    alert('Вы не выбрали способ доставки')
                    return
                }
                $.ajax({
                    url: '/api{$key}/methods/checkout.setdelivery?delivery_id='+this.delivery_type
                }).done((e)=>{
                    return
                })
                $.ajax({
                    url: '/api{$key}/methods/payment.getlist'
                }).done((e)=>{
                    this.payments = e.response.list
                    return
                })
                this.design_step = 2
        },
        checkout(){
            if (this.payment_id==0){
                alert('Вы не выбрали способ оплаты')
                return
            }
            $.ajax({
                    url: '/api{$key}/methods/checkout.setpayment?payment_id='+this.payment_id
                }).done((e)=>{
                    return
                })
            $.ajax({
                url: '/api{$key}/methods/checkout.confirm?v=2'
            }).done((e)=>{
                console.log(e)
                let order_num = e.response.order.order_num
                let url_online = e.response.order.pay_url
                let can = e.response.order.pay_url.can_online_pa
                let text = "Ваш номер заказа - "+order_num
            let data = {literal}{'message':text, 'id': this.user_tg.id}{/literal}
            $.ajax({
                url: '/api{$key}/methods/telegram.send',
                data: data,
            }).done((e)=>{
                console.log(e)
                if (can){
                    let text_url = "Ваша ссылка на оплату - "+url_online
                    data = {literal}{'message':text_url, 'id': this.user_tg.id}{/literal}
                $.ajax({
                    url: '/api{$key}/methods/telegram.send',
                    data: data,
                }).done((e)=>{
                    console.log(e)
                return
                })
                }
                return
            })
                return
            })
            products_cart = []
            this.design_step = 3
            tg.BackButton.hide()
            tg.MainButton.hide()
            setTimeout(function(){
                app.page = ''
                app.header_show = true
            },3000);
        },
        remove_product(id){
            $.ajax({
                url: '/api{$key}/methods/cart.remove?id='+id
            }).done((e)=>{
                for (let i = 0; i<this.products_cart.length;i++){
                    if (this.products_cart[i].id==id){
                        this.products_cart.splice(i,1)
                    }
                }
                this.total = e.response.cartdata.total
                if (e.response.cartdata.items.length==0){
                    this.page=''
                    tg.BackButton.hide()
                    tg.MainButton.hide()
                    this.header_show = true
                }
                return
            })
        },
        mainpage(){
            this.page=""
        },
        change_price(){
            for (var i = 0; i<this.offers.length;i++){
                if (JSON.stringify(this.offers[i].propsdata_arr)===JSON.stringify(this.multioffers_selected)){
                    this.offer_price = this.offers[i].cost_values.cost_format
                    this.offer_id = this.offers[i].id
                    break
                }else{
                    this.offer_price = ''
                }
            }
        },
        change_offer(){
            for (var i = 0; i<this.offers.length;i++){
                if (this.offers[i].id == this.offer_id){
                    this.offer_price = this.offers[i].cost_values.cost_format
                }
            }
        },
    }
})
</script>
<script>
$.ajax({
    url: '/api{$key}/methods/cart.getcartdata',
}).done((e)=>{
    for (let i = 0; i<e.response.cartdata.items.length; i++){
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&amp;", '&')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&gt;",'>')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&lt;",'<')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&quot;",'"')
    }
    app.products_cart = e.response.cartdata.items
    app.total = e.response.cartdata.total
    if (e.response.cartdata.items.length!=0){
        for (let i = 0; i<app.products_cart.length; i++){
            $.ajax({
                url: '/api{$key}/methods/products.get_description?product_id='+app.products_cart[i].entity_id,
                async: false,
            }).done((res)=>{
                app.products_cart[i].short_description = res.response.product
            })
            $.ajax({
                url: '/api{$key}/methods/products.get_num?product_id='+app.products_cart[i].entity_id,
                async: false,
            }).done((res)=>{
                if (parseInt(res.response.num)>100){
                    app.products_cart[i].num = 100
                }else{
                    app.products_cart[i].num = parseInt(res.response.num)
                }
                
            })
            if (app.products_cart[i].type=="offers"){
                     $.ajax({
                        url: '/api{$key}/methods/product.getofferslist?product_id='+app.products_cart[i].entity_id,
                        async: false,
                    }).done((off)=>{
                        for (var j = 0; j<off.response.offers.length;j++){
                            if (off.response.offers[j].id==app.products_cart[i].offer){
                                app.products_cart[i].offer_title = off.response.offers[j].title
                            }
                        }
                        
                    })
            }
        }
    tg.MainButton.text = '🛒 Корзина'
    tg.MainButton.show()
    }
    return
})
</script>
<script>
Telegram.WebApp.onEvent('mainButtonClicked', function(){
    if (app.page!='cart'){
        $.ajax({
            url: '/api{$key}/methods/cart.getcartdata',
        }).done((e)=>{
            for (let i = 0; i<e.response.cartdata.items.length; i++){
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&amp;", '&')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&gt;",'>')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&lt;",'<')
                    e.response.cartdata.items[i].title = e.response.cartdata.items[i].title.replaceAll("&quot;",'"')
            }
            app.products_cart = e.response.cartdata.items
            app.total = e.response.cartdata.total
            for (let i = 0; i<app.products_cart.length; i++){
            $.ajax({
                url: '/api{$key}/methods/products.get_description?product_id='+app.products_cart[i].entity_id,
                async: false,
            }).done((res)=>{
                app.products_cart[i].short_description = res.response.product
                return
            })
            $.ajax({
                url: '/api{$key}/methods/products.get_num?product_id='+app.products_cart[i].entity_id,
                async: false,
            }).done((res)=>{
                if (parseInt(res.response.num)>100){
                    app.products_cart[i].num = 100
                }else{
                    app.products_cart[i].num = parseInt(res.response.num)
                }
                return
            })
            if (app.products_cart[i].type=="offers"){
                     $.ajax({
                        url: '/api{$key}/methods/product.getofferslist?product_id='+app.products_cart[i].entity_id,
                        async: false,
                    }).done((off)=>{
                        for (var j = 0; j<off.response.offers.length;j++){
                            if (off.response.offers[j].id==app.products_cart[i].offer){
                                app.products_cart[i].offer_title = off.response.offers[j].title
                            }
                        }
                        return
                    })
            }
            }
            return
        })
        app.page = 'cart'
        tg.MainButton.text = 'Оформить заказ'
        tg.BackButton.show()
        app.header_show = false
    }else{
            $.ajax({
                url: '/api{$key}/methods/checkout.init'
            }).done((e)=>{
                return
            })
            $.ajax({
                url: '/api{$key}/methods/checkout.getaddresslistsinfo?sections[]=country'
            }).done((e)=>{
                app.countries = e.response.lists.country
                return
            })
            app.page="design"
            app.design_step = 0
            tg.MainButton.hide()
            tg.BackButton.show()
            app.header_show = false
    }
})
</script>
<script>
Telegram.WebApp.onEvent('backButtonClicked', function(){
    if (app.page=='design'){
        app.page='cart'
        tg.MainButton.text = 'Оформить заказ'
        tg.MainButton.show()
        app.header_show = false
    }else{
        app.page=''
        tg.MainButton.text = '🛒 Корзина'
        tg.MainButton.show()
        tg.BackButton.hide()
        app.header_show = true
    }
})
</script>
</body>
</html>
