class Audit < Sequel::Model

  many_to_one :auditable, reciprocal: :audits,
                          setter: (proc do |auditable|
                              self[:auditable_id] = (auditable.pk if auditable)
                              self[:auditable_type] = (auditable.class.name if auditable)
                            end),
                            dataset: (proc do
                              klass = auditable_type.constantize
                              klass.where(klassprimary_key: auditable_id)
                            end),
                            eager_loader: (proc do |eo|
                              id_map = {}
                              eo[:rows].each do |asset|
                                asset.associations[:auditable] = nil
                                ((id_map[asset.auditable_type] ||= {})[asset.auditable_id] ||= []) << asset
                              end
                              id_map.each do |klass_name, id_map|
                                klass = klass_name.constantize
                                klass.where(klassprimary_key: id_map.keys).all do |attach|
                                  id_map[attach.pk].each do |asset|
                                    asset.associations[:auditable] = attach
                                  end
                                end
                              end
                            end)
end
