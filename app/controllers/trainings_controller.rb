class TrainingsController < ApplicationController
  before_action :set_training, only: %i[ show edit update destroy ]
  before_action :set_max_weight


  # GET /trainings or /trainings.json
  def index
    if params[:user_id] # 他人のトレーニング
      @user = User.find(params[:user_id])

      if @user.team_id != current_user.team_id
        redirect_to users_path, alert: "他チームの選手の情報にはアクセスできません"
        return
      end

      @trainings = @user.trainings.order(datetime: :desc).page(params[:page])

    else # 自分のトレーニング
      @user = current_user
      @trainings = current_user.trainings.order(datetime: :desc).page(params[:page])
    end
  end

  # GET /trainings/1 or /trainings/1.json
  def show
    @training = Training.find(params[:id])
    @user = @training.user
  end

  # GET /trainings/new
  def new
    @training = Training.new


    MaxWeight.all.each do |max_weight|
      @training.training_max_weights.find_or_initialize_by(max_weight: max_weight)
    end
  end

  # GET /trainings/1/edit
  def edit
    MaxWeight.all.each do |max_weight|
      @training.training_max_weights.find_or_initialize_by(max_weight: max_weight)
    end
  end

  # POST /trainings or /trainings.json
  def create
    @training = Training.new(training_params)
    @training.user = current_user


    respond_to do |format|
      if @training.save
        format.html { redirect_to @training, notice: t('trainings.create.success') }
        format.json { render :show, status: :created, location: @training }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @training.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trainings/1 or /trainings/1.json
  def update
    respond_to do |format|
      if @training.update(training_params)
        format.html { redirect_to @training, notice: t('trainings.update.success') }
        format.json { render :show, status: :ok, location: @training }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @training.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trainings/1 or /trainings/1.json
  def destroy
    @training.destroy!

    respond_to do |format|
      format.html { redirect_to trainings_path, status: :see_other, notice: t('trainings.destroy.success') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_training
      @training = Training.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def training_params
      params.require(:training).permit(:user_id, :datetime, :part, :content, :memo, :body_weight, :body_fat, training_max_weights_attributes: [ :id, :max_weight_id, :record, :_destroy ]).merge(user_id: current_user.id)
    end


    def set_max_weight
      @max_weights = MaxWeight.all.index_by(&:id)
    end
end
