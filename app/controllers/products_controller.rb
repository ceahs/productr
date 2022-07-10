class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy place_order ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorise_user, only: [:edit, :update, :destroy]
  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  # Creates a new product in the database, with the params specificed in product_params as the current_user
  def create
    @product = Product.new(product_params)
    @product.user = current_user


    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
#  Gets the product id, the id of the user who created the product, and then the current users id (the buyer)
# to create an order in the db.
  def place_order
    Order.create(
      product_id: @product.id,
      seller_id: @product.user_id,
      buyer_id: current_user.id
    )

    redirect_to order_success_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def authorise_user
      if @product.user_id != current_user.id
        flash[:alert] = "You can't access this page."
        redirect_to products_path
      end
    end

    # Only allow a list of trusted parameters through.
    # All these parameters are shown on the show page besides user_id. The information is requested by the
    # create method
    def product_params
      params.require(:product).permit(:title, :description, :price, :user_id, :picture)
    end
end
