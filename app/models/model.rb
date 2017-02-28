class Model
	include HTTParty
  	format :json
  	base_uri BASE_URI + '/models'

  	attr_accessor :modelID, :modelStatus, :pngUrl, :zipUrl, :thumbUrl, :threshold

  	def initialize(modelID, modelStatus, pngUrl, zipUrl, thumbUrl, threshold)
  		self.modelID = modelID
      self.modelStatus = modelStatus
	    self.pngUrl = pngUrl
      self.zipUrl = zipUrl
	    self.thumbUrl = thumbUrl
	    self.threshold = threshold
  	end

    # Gets an array of thresholds of the species continuous model developed by BioModelos via API.  
    #
    # @param species_id [Number] ID of the species.
    # @return [Array] Thresholds models objects.
    def self.get_thresholds(species_id)
      response = JSON.parse(get('/' + species_id + '?type=Thresholds').body)
      thresholds_array = []
      response.each do |threshold|
        t = Model.new(threshold["modelID"], threshold["modelStatus"], threshold["pngPath"], threshold["zipPath"], threshold["thumbPath"], threshold["thresholdType"])
        thresholds_array.push(t)
      end
      return thresholds_array
    end

  	def self.get_hypotheses(species_id)
  		response = JSON.parse(get('/' + species_id + '?type=Hypothesis').body)
  		hypotheses_array = []
    	response.each do |hypothesis|
    		t = Model.new(threshold["Modelo"], threshold["ModelStatus"], threshold["Ruta_Mapa"], threshold["Ruta_Tif"], threshold["Ruta_Miniatura"], threshold["Umbral"])
    		models_array.push(t)
      end

		  return models_array
  	end

    # Gets a species continuous model developed by BioModelos via API.  
    #
    # @param species_id [Number] ID of the species.
    # @return [Object] Continuous model object.
    def self.get_continous_model(species_id)
      response = JSON.parse(get('/' + species_id + '?type=Continuous').body)
      if response.size > 0
        continuous_model = Model.new(response[0]["modelID"], response[0]["modelStatus"], response[0]["pngPath"], response[0]["zipPath"], response[0]["thumbPath"], response[0]["thresholdType"])
      else
        continuous_model = nil
      end

      return continuous_model
    end

    # Gets a species validated model via API.  
    #
    # @param species_id [Number] ID of the species.
    # @return [Object] Valid model object.
    def self.get_valid_model
      response = JSON.parse(get('/' + species_id + '?tipo=Valid').body)
      if response.size > 0
        valid_model = Model.new(response[0]["modelID"], response[0]["modelStatus"], response[0]["pngPath"], response[0]["zipPath"], response[0]["thumbPath"], response[0]["thresholdType"])
      else
        valid_model = nil
      end

      return valid_model
    end

    def self.eoo(species_id)
      JSON.parse(get('/approved/eoo/' + species_id).body)
    end

    def self.rpa(species_id)
      JSON.parse(get('/approved/rpa/' + species_id).body)
    end

    def self.forest_loss(species_id)
      JSON.parse(get('/approved/forest_loss/' + species_id).body)
    end

    def self.covers(species_id)
      JSON.parse(get('/approved/covers/' + species_id).body)
    end

    def self.get_metadata(model_id)
      JSON.parse(get('/metadata/' + model_id.to_s).body)
    end

end